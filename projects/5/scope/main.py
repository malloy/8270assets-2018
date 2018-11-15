x = 99

def f():
  x = x + 7
  print x
  def g():
    print x
  g()



f()
print x
