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

my $pwm_value_file = '/sys/class/gpio/gpio11/value';

my $index_document = Plack::App::File->new( file => 'root/index.html')->to_app;

my $pwm_control = sub {
    my $env = shift; # PSGI env

    my $req = Plack::Request->new($env);

    my $value = $req->param('v');
    $value += 0; # make number
    $value = 0 if ($value <= 0);
    $value = 1023 if ($value > 1023);

    my $res = $req->new_response(200);
    $res->content_type('application/json');

    my $fh = new IO::File '> '.$pwm_value_file;
    if (defined $fh) {
        print $fh $value."\n";
        $fh->close;	
        $res->body('{"result": "ok"}');
    } else {
        $res->body('{"result": "fail"}');
    }
    $res->finalize;
};

builder {
    mount "/set-pwm.json" => builder {
        $pwm_control;
    };

    mount "/" => builder {
        enable 'ReverseProxy';
        enable 'ConditionalGET';

        enable 'Deflater',
                content_type => ['text/css','text/html','text/javascript',
                'application/javascript'], vary_user_agent => 1;

	enable 'Static',
          path => qr{^/(images|js|css)/}, root => 'root';

	$index_document;
    };
};
