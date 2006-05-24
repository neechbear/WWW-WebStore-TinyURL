# $Id$

chdir("t") if -d "t";

use strict;
use Test::More tests => 8;

use lib qw(./lib ../lib);
use WWW::WebStore::TinyURL;

{
	my ($store,$store2,$data,$url);
	my $source_data = "Hello World!";
	eval {
		
		$store = WWW::WebStore::TinyURL->new(\$source_data);
		$url = $store->url;
		$store2 = WWW::WebStore::TinyURL->new($url);
		$data = $store2->data;
	};
	ok(ref($store) eq 'WWW::WebStore::TinyURL','WWW::WebStore::TinyURL->new("\$source_data")');
	ok(ref($store2) eq 'WWW::WebStore::TinyURL','WWW::WebStore::TinyURL->new($url)');
	ok($url =~ m,^http://tinyurl\.com/[a-zA-Z0-9]+$,,'url()');
	ok($data eq $source_data,'data()');

}

{
	my ($store,$store2,$data,$url);
	my $source_data = "perl Build.PL\nperl Build\nperl Build test\nperl Build install\n";
	eval {
		$store = WWW::WebStore::TinyURL->new("../INSTALL");
		$url = $store->url;
		$store2 = WWW::WebStore::TinyURL->new($url);
		$data = $store2->data;
	};
	ok(ref($store) eq 'WWW::WebStore::TinyURL','WWW::WebStore::TinyURL->new("../INSTALL")');
	ok(ref($store2) eq 'WWW::WebStore::TinyURL','WWW::WebStore::TinyURL->new($url)');
	ok($url =~ m,^http://tinyurl\.com/[a-zA-Z0-9]+$,,'url()');
	ok($data eq $source_data,'data()');
}

1;


