"""PEF-05R finite integer discrepancy envelope independent oracle."""
import unittest


def envelope(initial,L,eps,n):
    e=initial
    for _ in range(n):
        e=L*e+eps
    return e


class GradientStabilityTests(unittest.TestCase):
    def test_zero_local_error_and_identical_start(self):
        for L in range(9):
            for n in range(20):
                self.assertEqual(envelope(0,L,0,n),0)

    def test_exact_small_numeric_witnesses(self):
        self.assertEqual(envelope(0,2,1,5),31)
        self.assertEqual(envelope(0,1,1,5),5)
        self.assertEqual(envelope(0,8,3,1),3)

    def test_scalar_bound_recursion_for_arbitrary_admissible_paths(self):
        for L in range(6):
            for eps in range(5):
                for initial in range(4):
                    d=initial
                    for n in range(25):
                        self.assertLessEqual(d,envelope(initial,L,eps,n))
                        # Valid d_(n+1)<=L*d_n+eps; choose a
                        # representative smaller than its upper bound.
                        d=max(0,L*d+eps-(n%3))

    def test_envelope_monotone_in_initial(self):
        for L in range(6):
            for eps in range(4):
                for n in range(12):
                    self.assertLessEqual(envelope(0,L,eps,n),
                                         envelope(2,L,eps,n))


if __name__=="__main__":
    unittest.main()
