"""SPC-05: exact rational independent oracles for phase-latch mathematics."""
from fractions import Fraction as Q
from itertools import product
import unittest


def f(x: Q) -> Q:
    return 1-3*x*x+2*x*x*x


def df(x: Q) -> Q:
    return -6*x+6*x*x


def driven_step(state: tuple[Q,Q], lam: Q, beta: Q):
    c,a=state
    return (lam*c+beta*a,f(a))


def cycle_states(lam: Q, beta: Q):
    c0=beta/(1-lam*lam)
    return (c0,Q(0)),(lam*c0,Q(1))


def walk(x, lam, beta, n):
    for _ in range(n):
        x=driven_step(x,lam,beta)
    return x


class PhaseLatchExactTests(unittest.TestCase):
    def test_forced_context_orbit_and_derivatives_exact(self):
        for lam,beta in [(Q(1,2),Q(1)), (Q(-1,3),Q(2,3)), (Q(3,5),Q(-2))]:
            a,b=cycle_states(lam,beta)
            self.assertEqual(driven_step(a,lam,beta),b)
            self.assertEqual(driven_step(b,lam,beta),a)
            self.assertEqual(df(Q(0)),Q(0));self.assertEqual(df(Q(1)),Q(0))
            self.assertLess(abs(lam),1)
            # Triangular Jacobian matrix at both exact phase states.
            self.assertEqual([[lam,beta],[Q(0),Q(0)]],[[lam,beta],[0,df(a[1])]])

    def test_exact_answer_and_context_transplant_dynamics(self):
        for lam,beta in [(Q(1,2),Q(1)), (Q(1,3),Q(2)), (Q(-1,4),Q(3,2))]:
            x0,x1=cycle_states(lam,beta)
            answer_hybrid=(x0[0],x1[1])
            context_hybrid=(x1[0],x0[1])
            for n in range(20):
                next_reference=walk(x1,lam,beta,n)
                current_reference=walk(x0,lam,beta,n)
                answer_effect=walk(answer_hybrid,lam,beta,n)
                context_effect=walk(context_hybrid,lam,beta,n)
                self.assertEqual(answer_effect[1],next_reference[1])
                self.assertEqual(context_effect[1],current_reference[1])
                self.assertEqual(answer_effect[0]-next_reference[0],lam**n*(x0[0]-x1[0]))
                self.assertEqual(context_effect[0]-current_reference[0],lam**n*(x1[0]-x0[0]))

    def test_energy_partition_and_hybrid_nearest_identity(self):
        sqdist=lambda x,y:(x[0]-y[0])**2+(x[1]-y[1])**2
        for c0,c1,a0,a1 in product(range(-2,3),repeat=4):
            x=(c0,a0);y=(c1,a1);z=(c0,a1)
            d_c=(c1-c0)**2;d_a=(a1-a0)**2
            self.assertEqual(sqdist(x,y),d_c+d_a)
            self.assertEqual(sqdist(z,y),d_c)
            self.assertEqual(sqdist(z,x),d_a)
            self.assertEqual(sqdist(z,y)<sqdist(z,x),d_c<d_a)

    def test_phase_contrasts_span_at_most_q_minus_one(self):
        import numpy as np
        for q in (2,3,5,8):
            # Integer codewords in arbitrary ambient dimension 20.
            code=np.random.default_rng(332+q).integers(-7,8,size=(q,20),dtype=np.int64)
            anchor=code-code[0]
            contrasts=np.array([code[i]-code[j] for i in range(q) for j in range(q)])
            self.assertLessEqual(np.linalg.matrix_rank(contrasts.astype(float)),q-1)
            self.assertTrue(all(np.array_equal(code[i]-code[j],anchor[i]-anchor[j])
                                for i in range(q) for j in range(q)))

    def test_finite_boolean_driven_phase(self):
        def step(state):return (state[1], not state[1])
        x0=(True,False);x1=(False,True)
        self.assertEqual(step(x0),x1)
        self.assertEqual(step(x1),x0)
        self.assertEqual(step((x0[0],x1[1])),step(x1))
        self.assertEqual(step((x1[0],x0[1])),step(x0))

if __name__=='__main__':unittest.main()
