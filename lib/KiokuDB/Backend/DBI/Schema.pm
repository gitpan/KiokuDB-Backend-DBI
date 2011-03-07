#!/usr/bin/perl

package KiokuDB::Backend::DBI::Schema;
BEGIN {
  $KiokuDB::Backend::DBI::Schema::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $KiokuDB::Backend::DBI::Schema::VERSION = '1.19';
}
use Moose;

use namespace::clean -except => 'meta';

extends qw(DBIx::Class::Schema);

__PACKAGE__->load_components(qw(Schema::KiokuDB));

__PACKAGE__

__END__
