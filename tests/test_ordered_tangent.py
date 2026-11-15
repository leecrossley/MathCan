"""Independent integer-grid PEF-03 noncommuting Jacobian oracle."""
import unittest


def U(a, b):
    return a+b, b


def D(a, b):
    return a, a+b


def sq(z):
    return z[0]**2 + z[1]**2


def area(v, w):
    return v[0]*w[1]-v[1]*w[0]


class OrderedJacobianTests(unittest.TestCase):
    def test_noncommuting_exact_witness_and_general_commutator(self):
        self.assertEqual(U(*D(1,0)), (2,1))
        self.assertEqual(D(*U(1,0)), (1,1))
        self.assertEqual(sq(U(*D(1,0))),5)
        self.assertEqual(sq(D(*U(1,0))),2)
        self.assertEqual(sq(U(*D(0,1))),2)
        self.assertEqual(sq(D(*U(0,1))),5)
        for x in range(-8,9):
            for y in range(-8,9):
                lhs=U(*D(x,y))
                rhs=D(*U(x,y))
                self.assertEqual((lhs[0]-rhs[0],lhs[1]-rhs[1]),(x,-y))

    def test_same_each_step_area_and_singular_proxy(self):
        for a in range(-3,4):
            for b in range(-3,4):
                for c in range(-3,4):
                    for d in range(-3,4):
                        self.assertEqual(area(U(a,b),U(c,d)),a*d-b*c)
                        self.assertEqual(area(D(a,b),D(c,d)),a*d-b*c)


if __name__=="__main__":
    unittest.main()
