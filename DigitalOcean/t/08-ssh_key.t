#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

unless($ENV{API_KEY} and $ENV{CLIENT_ID}) {
	plan skip_all => 'API_KEY and CLIENT_ID not set';
}
else {
	plan tests => 4;
}

use_ok( 'DigitalOcean' ) || print "Bail out!\n";

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);
my $ssh_key_name = 'test-' . time() . '-' . int(rand(100));
my $ssh_pub_key = "ssh-dss AAAAB3NzaC1kc3MAAACBAK5uLwicCrFEpaVKBzkWxC7RQn+smg5ZQb5keh9RQKo8AszFTol5npgUAr0JWmqKIHv7nof0HndO86x9iIqNjq3vrz9CIVcFfZM7poKBJZ27Hv3v0fmSKfAc6eGdx8eM9UkZe1gzcLXK8UP2HaeY1Y4LlaHXS5tPi/dXooFVgiA7AAAAFQCQl6LZo/VYB9VgPEZzOmsmQevnswAAAIBCNKGsVP5eZ+IJklXheUyzyuL75i04OOtEGW6MO5TymKMwTZlU9r4ukuwxty+T9Ot2LqlNRnLSPQUjb0vplasZ8Ix45JOpRbuSvPovryn7rvS7//klu9hIkFAAQ/AZfGTw+696EjFBg4F5tN6MGMA6KrTQVLXeuYcZeRXwE5t5lwAAAIEAl2xYh098bozJUANQ82DiZznjHc5FW76Xm1apEqsZtVRFuh3V9nc7QNcBekhmHp5Z0sHthXCm1XqnFbkRCdFlX02NpgtNs7OcKpaJP47N8C+C/Yrf8qK/Wt3fExrL2ZLX5XD2tiotugSkwZJMW5Bv0mtjrNt0Q7P45rZjNNTag2c= user\@host";
my $new_ssh_pub_key = "ssh-dss AAAAB3NzaC1kc3MAAACBAK5uLwicCrFEpaVKBzkWxC7RQn+xmg5ZQb5keh9RQKo8AszFTol5npgUAr0JWmqKIHv7nof0HndO86x9iIqNjq3vrz9CIVcFfZM7poKBJZ27Hv3v0fmSKfAc6eGdx8eM9UkZe1gzcLXK8UP2HaeY1Y4LlaHXS5tPi/dXooFVgiA7AAAAFQCQl6LZo/VYB9VgPEZzOmsmQevnswAAAIBCNKGsVP5eZ+IJklXheUyzyuL75i04OOtEGW6MO5TymKMwTZlU9r4ukuwxty+T9Ot2LqlNRnLSPQUjb0vplasZ8Ix45JOpRbuSvPovryn7rvS7//klu9hIkFAAQ/AZfGTw+696EjFBg4F5tN6MGMA6KrTQVLXeuYcZeRXwE5t5lwAAAIEAl2xYh098bozJUANQ82DiZznjHc5FW76Xm1apEqsZtVRFuh3V9nc7QNcBekhmHp5Z0sHthXCm1XqnFbkRCdFlX02NpgtNs7OcKpaJP47N8C+C/Yrf8qK/Wt3fExrL2ZLX5XD2tiotugSkwZJMW5Bv0mtjrNt0Q7P45rZjNNTag2c= user\@host";

my $ssh_key = $do->create_ssh_key(
				name => $ssh_key_name,
				ssh_pub_key => $ssh_pub_key,
			  );

isa_ok($ssh_key, 'DigitalOcean::SSH::Key');

#get ssh key
$ssh_key = $do->ssh_key($ssh_key->id);
isa_ok($ssh_key, 'DigitalOcean::SSH::Key');

#edit
$ssh_key->edit(ssh_pub_key => $new_ssh_pub_key);

ok($ssh_key->ssh_pub_key eq $new_ssh_pub_key, 'New ssh_pub_key successfully updated');

#destroy
$ssh_key->destroy;
