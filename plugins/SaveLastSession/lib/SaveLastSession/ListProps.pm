package SaveLastSession::ListProps;
use strict;
use warnings;

use MT::Util qw( offset_time_list );

sub author {
    return {
        last_session => {
            base      => '__virtual.integer',
            label     => 'Last Session',
            display   => 'default',
            raw       => \&_raw,
            bulk_sort => \&_bulk_sort,
        },
    };
}

sub _raw {
    my ( $prop, $obj, $app ) = @_;

    my $last_sess = $obj->last_session;
    if ( !$last_sess ) {
        return $last_sess;
    }

    my @ts = offset_time_list($last_sess);
    my $ts = sprintf '%04d-%02d-%02d %02d:%02d:%02d',
        $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];

    return $ts;
}

sub _bulk_sort {
    my ( $prop, $objs ) = @_;
    return sort { $a->last_session <=> $b->last_session } @$objs;
}

1;
__END__
