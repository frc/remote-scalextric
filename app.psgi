#!/usr/bin/env perl
use strict;
use warnings;
use IO::File;
use Plack::Builder;
use Plack::Middleware::Header;
use Plack::Middleware::Static;
use Plack::Middleware::Deflater;
use Plack::Request;
use Plack::App::File;

autoflush STDOUT 1;

my $gpio_cmd = '/usr/local/bin/gpio';
my $gpio_pin = '1';

system($gpio_cmd, 'mode', $gpio_pin, 'pwm');

my $index_document = Plack::App::File->new( file => 'root/index.html')->to_app;

my $pwm_control = sub {
    my $env = shift; # PSGI env

    my $req = Plack::Request->new($env);

    my $value = $req->param('v');
    $value += 0; # make number
    $value = 0 if ($value <= 0);
    $value = 1023 if ($value > 1023);

    system($gpio_cmd, 'pwm', $gpio_pin, $value);

    my $res = $req->new_response(200);
    $res->content_type('application/json');
    $res->body('{"result": "ok"}');
    $res->finalize;
};

builder {
    mount "/set-pwm.json" => builder {
        $pwm_control;
    };

    mount "/assets" => builder {
        enable 'ReverseProxy';
        enable 'ConditionalGET';

        enable 'Deflater',
                content_type => ['text/css','text/html','text/javascript',
                'application/javascript'], vary_user_agent => 1;

	enable 'Static', path => qr{^/}, root => 'root/assets';
    };

    mount "/" => builder {
        enable 'ReverseProxy';
        enable 'ConditionalGET';

        enable 'Deflater',
                content_type => ['text/css','text/html','text/javascript',
                'application/javascript'], vary_user_agent => 1;

	$index_document;
    };
};
