run_program() -> (
  loop( 10,
    // looping 10 times
    // comments are allowed in scripts located in world files
    // since we can tell where that line ends
    foo = floor(rand(10));
    check_not_zero(foo);
    print(_+' - foo: '+foo);
    print('  reciprocal: '+  _/foo )
  )
);
check_not_zero(foo) -> (
  if (foo==0, foo = 1)
)