"""Independent exact integer audit for PEF-03G four-corner interaction."""
import itertools
import unittest


def linear(x,y):
    return 3*x + 5*y + 1


def quadratic(x,y):
    return x*y


def interaction(F, x0, y0, x1, y1):
    return F(x1,y1)-F(x1,y0)-F(x0,y1)+F(x0,y0)


class CausalInteractionTests(unittest.TestCase):
    def test_universal_integer_four_corner_decomposition(self):
        for a, b, c, d in itertools.product(range(-3,4), repeat=4):
            natural=b-a
            row=c-a
            null=d-a
            inter=b-c-d+a
            self.assertEqual(natural,row+null+inter)

    def test_linear_interactions_zero(self):
        for x0,y0,x1,y1 in itertools.product(range(-2,3), repeat=4):
            self.assertEqual(interaction(linear,x0,y0,x1,y1),0)

    def test_nonlinear_quadratic_interaction_witness(self):
        self.assertEqual(interaction(quadratic,0,0,1,1),1)
        self.assertEqual(quadratic(1,0),0)
        self.assertEqual(quadratic(0,1),0)
        self.assertEqual(quadratic(1,1),1)

    def test_head_kernel_and_future_shear(self):
        def H(z): return z[0]
        def U(z): return (z[0]+z[1],z[1])
        for x,y,delta in itertools.product(range(-4,5), repeat=3):
            self.assertEqual(H((x,y+delta)),H((x,y)))
        self.assertEqual(H((0,1)),0)
        self.assertEqual(H(U((0,1))),1)


if __name__=='__main__':
    unittest.main()
