package KiokuDB::TypeMap::Entry::DBIC::ResultSource;
BEGIN {
  $KiokuDB::TypeMap::Entry::DBIC::ResultSource::AUTHORITY = 'cpan:NUFFIN';
}
BEGIN {
  $KiokuDB::TypeMap::Entry::DBIC::ResultSource::VERSION = '1.19';
}
use Moose;

use Scalar::Util qw(weaken refaddr);

use namespace::autoclean;

with qw(KiokuDB::TypeMap::Entry);

sub compile {
    my ( $self, $class ) = @_;

    return KiokuDB::TypeMap::Entry::Compiled->new(
        collapse_method => sub {
            my ( $collapser, @args ) = @_;

            $collapser->collapse_first_class(
                sub {
                    my ( $collapser, %args ) = @_;

                    if ( refaddr($collapser->backend->schema) == refaddr($args{object}->schema) ) {
                        return $collapser->make_entry(
                            %args,
                            data => undef,
                            meta => {
                                immortal => 1,
                            },
                        );
                    } else {
                        croak("Referring to foreign DBIC schemas is unsupported");
                    }
                },
                @args,
            );
        },
        expand_method => sub {
            my ( $linker, $entry ) = @_;

            my $schema = $linker->backend->schema;

            my $rs = $schema->source(substr($entry->id, length('dbic:schema:rs:')));

            $linker->register_object( $entry => $rs, immortal => 1 );

            return $rs;
        },
        id_method => sub {
            my ( $self, $object ) = @_;

            return 'dbic:schema:rs:' . $object->source_name;
        },
        refresh_method => sub { },
        entry => $self,
        class => $class,
    );
}


__PACKAGE__->meta->make_immutable;

# ex: set sw=4 et:

__PACKAGE__

__END__

=pod

=head1 NAME

KiokuDB::TypeMap::Entry::DBIC::ResultSource - L<KiokuDB::TypeMap::Entry>
for L<DBIx::Class::ResultSource> objects.

=head1 DESCRIPTION

This tyepmap entry resolves result source handles symbolically by name.

References to the handle receive a special ID in the form:

    dbic:schema:rs:$name

and are not actually written to storage.

Looking up such an ID causes the backend to dynamically search for such a
resultset in the L<DBIx::Class::Schema>.
