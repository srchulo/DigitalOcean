package DigitalOcean::Types;

# predeclare our own types
use MouseX::Types 
  -declare => [qw(
      PositiveInt 
  )];

# import builtin types
use MouseX::Types::Mouse 'Int';

# type definition.
subtype PositiveInt, 
    as Int, 
    where { $_ > 0 },
    message { "Int is not larger than 0" };
  
1;
