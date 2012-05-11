package MT::Plugin::SaveLastSession;
use strict;
use warnings;
use base 'MT::Plugin';

our $VERSION = '0.01';
our $NAME = ( split /::/, __PACKAGE__ )[-1];

my $plugin = __PACKAGE__->new(
    {   name        => $NAME,
        id          => lc $NAME,
        key         => lc $NAME,
        l10n_class  => $NAME . '::L10N',
        version     => $VERSION,
        author_name => 'masiuchi',
        author_link => 'https://github.com/masiuchi',
        plugin_link =>
            'https://github.com/masiuchi/mt-plugin-save-last-session',
        description => 'Save user last access datetime.',
        registry    => {
            object_types =>
                { author => { last_session => 'integer meta', }, },
            list_properties => {
                author => '$' . $NAME . '::' . $NAME . '::ListProps::author',
            },
            callbacks => { take_down => \&_take_down, },
        },
    }
);
MT->add_plugin($plugin);

sub _take_down {
    my $app = MT->app();
    if ( !$app ) {
        return;
    }

    my $user = $app->user();
    if ( !$user ) {
        return;
    }

    $user->last_session(time);
    $user->update()
        or die $app->error(
        $NAME . ' : Cannot save last_session of MT::Author.' );
}

1;
__END__
