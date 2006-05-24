############################################################
#
#   $Id$
#   WWW::WebStore::TinyURL - Store data and files in TinyURLs
#
#   Copyright 2006 Nicola Worthington
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
############################################################

package WWW::WebStore::TinyURL;
# vim:ts=4:sw=4:tw=78

use strict;
use File::Slurp qw();
use LWP::UserAgent qw();
use Carp qw(croak carp);

use vars qw($VERSION $DEBUG $UA);

$VERSION = '0.01' || sprintf('%d', q$Revision$ =~ /(\d+)/g);
$DEBUG = $ENV{DEBUG} ? 1 : 0;

$UA = LWP::UserAgent->new(
		timeout => 20,
		agent => __PACKAGE__ . ' $Id$',
	#	agent => 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.8) '.
	#			'Gecko/20050718 Firefox/1.0.4 (Debian package 1.0.4-2sarge1)',
		max_redirect => 0,
	);
$UA->env_proxy;
$UA->max_size(1024*100);

sub new {
	TRACE("new()");
	ref(my $class = shift) && croak 'Class name required';
	my $input = shift;

	# Barf on naff paramaters
	croak "No paramater passed when filename or scalar reference or 'Tiny URL' was expected"
		unless defined $input;
	croak "Paramater '$input' is not a valid filename"
		if !ref($input) && !_isTinyURL($input) && !-f $input;
	croak "Paramater '$input' is not a scalar reference"
		if ref($input) && ref($input) ne 'SCALAR';

	# Put the nice data in the right place
	my $self = { url => undef, data => undef };
	if (!ref($input)) {
		if (_isTinyURL($input)) {
			$self->{url} = $input;
		} elsif (-f $input) {
			$self->{filename} = $input;
			$self->{data} = File::Slurp::read_file(
					$self->{filename},
					binmode => 'raw'
				);
		} else {
			croak "Unexpected logic error";
		}
	} elsif (ref($input) eq 'SCALAR') {
		$self->{data} = ${$input};
	} else {
		croak "Unexpected logic error";
	}

	# Bless you my child
	bless($self,$class);

	# Act on the data we were given
	$self->_store if defined $self->{data};
	$self->_retrieve if defined $self->{url};

	# Debug and return the object
	DUMP($class,$self);
	return $self;
}

sub url {
	TRACE("url()");
	my $self = shift;
	return $self->{url};
}

sub data {
	TRACE("data()");
	my $self = shift;
	return $self->{data};
}

sub _isTinyURL {
	TRACE("_isTinyURL()");
	return $_[0] =~ /^http:\/\/(?:www\.)?tinyurl\.com\/[a-zA-Z0-9]+$/i;
}

sub _retrieve {
	TRACE("_retrieve()");
	croak('Pardon?!') unless ref($_[0]) eq __PACKAGE__;
	my $self = shift;

	my $response = $UA->get($self->{url});
	TRACE($response->header("location"));
	unless ($self->{data}) {
		$self->{data} = $response->header('location');
		$self->{data} =~ s/^https?:\/\///i;
		$self->{data} = pack("H*",$self->{data});
	}
}

sub _store {
	TRACE("_store()");
	croak('Pardon?!') unless ref($_[0]) eq __PACKAGE__;
	my $self = shift;

	my $response = $UA->post(
						'http://tinyurl.com/create.php',
						[('url',unpack("H*",$self->{data}))]
					);
	return undef unless $response->is_success;

	TRACE('is_success');
	if ($response->content =~ m|<input\s+type=hidden\s+name=tinyurl\s+
						value="(http://tinyurl.com/[a-zA-Z0-9]+)">|x) {
		$self->{url} = $1;
		TRACE("url = $1");
	} else {
		TRACE("Couldn't extract tinyurl");
		DUMP("Content",$response->content);
	}
}

sub TRACE {
	return unless $DEBUG;
	warn(shift());
}

sub DUMP {
	return unless $DEBUG;
	eval {
		require Data::Dumper;
		warn(shift().': '.Data::Dumper::Dumper(shift()));
	}
}

1;

=pod

=head1 NAME

WWW::WebStore::TinyURL - Store data and files in TinyURLs

=head1 SYNOPSIS

 use strict;
 use WWW::WebStore::TinyURL
 
 my $store = WWW::WebStore::TinyURL->new("shopping_list.txt");
 my $url = $store->url;
 my $shopping_list = $store->data;
 
 my $store2 = WWW::WebStore::TinyURL->new("http://tinyurl.com/df97u");
 my $data2 = $store->data;
 
 my $data3 = WWW::WebStore::TinyURL->new($url)->data;
 
=head1 DESCRIPTION

WWW::WebStore::TinyURL will allow you to store data or small files
within a I<Tiny URL>, and retrieve it again at a later date using the
I<Tiny URL> as a key.

=head1 METHODS

=head2 new

 my $store = WWW::WebStore::TinyURL->new("http://tinyurl/df97u");
 my $store = WWW::WebStore::TinyURL->new("/var/tmp/filename.foo");
 my $store = WWW::WebStore::TinyURL->new(\$data);

Creates a new store object. Accepts a single argument which can be
a I<Tiny URL> (in order to retrieve data from a previously stored object),
a filename or a scalar reference to a string (which will be stored in a
I<Tiny URL>.

=head2 url

 my $tinyurl = $store->url;

Return the I<Tiny URL> or the stored object.

=head2 data

 my $data = $store->data;

Return the data from the stored object.

=head1 VERSION

$Id$

=head1 AUTHOR

Nicola Worthington <nicolaw@cpan.org>

L<http://perlgirl.org.uk>

=head1 COPYRIGHT

Copyright 2006 Nicola Worthington.

This software is licensed under The Apache Software License, Version 2.0.

L<http://www.apache.org/licenses/LICENSE-2.0>

=cut

__END__

