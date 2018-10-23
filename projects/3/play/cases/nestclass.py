def fun():
  class A:
    def __init__(self):
      if True:
        print "In A"
      else:
        print "Still in A"
  a = A()

fun()
