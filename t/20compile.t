# $Id$

chdir('t') if -d 't';
use lib qw(./lib ../lib);
use Test::More tests => 2;

use_ok('WWW::WebStore::TinyURL');
require_ok('WWW::WebStore::TinyURL');

1;

