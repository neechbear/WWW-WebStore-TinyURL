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
use Exporter;
use Carp qw(croak cluck confess carp);

use vars qw($VERSION);

$VERSION = '0.01' || sprintf('%d', q$Revision$ =~ /(\d+)/g);
$DEBUG = $ENV{DEBUG} ? 1 : 0;

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
 
=head1 DESCRIPTION

=head1 METHODS

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

