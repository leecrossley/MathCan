"""Independent exact old-bit pair-closure controls for PEF-04."""
from itertools import product
from hashlib import sha256
import random
import unittest


class PairClosedAccuracyTests(unittest.TestCase):
    def test_all_128_counterfactual_pairs_and_fixed_partition(self):
        suffixes=list(product((0,1),repeat=7))
        suffixes.sort(key=lambda s:(sha256(b"pef04-v1-pair:"+bytes(s)).digest(),bytes(s)))
        assert len(suffixes)==128
        cases=[suffixes[:80],suffixes[80:104],suffixes[104:]]
        self.assertEqual([len(c) for c in cases],[80,24,24])
        self.assertEqual(len(set.union(*(set(c) for c in cases))),128)
        for subset in cases:
            rows=[(bit,*suffix) for suffix in subset for bit in (0,1)]
            self.assertEqual(sum(1 for row in rows if row[0]==0),len(subset))
            self.assertEqual(sum(1 for row in rows if row[0]==1),len(subset))

    def test_any_suffix_only_predictions_get_exactly_one_per_pair(self):
        suffixes=list(product((0,1),repeat=7))
        rng=random.Random(14014804)
        for _ in range(100):
            table={s:rng.randrange(2) for s in suffixes}
            successes=sum(
                int(table[s]==0)+int(table[s]==1) for s in suffixes)
            both=sum(table[s]==0 and table[s]==1 for s in suffixes)
            self.assertEqual(successes,128)
            self.assertEqual(both,0)

    def test_jointly_correct_decoder_requires_hidden_state_difference(self):
        for predicted0,predicted1 in product((0,1),repeat=2):
            if predicted0==0 and predicted1==1:
                self.assertNotEqual(predicted0,predicted1)


if __name__=="__main__":
    unittest.main()
