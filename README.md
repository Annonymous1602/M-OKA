% M-OKA: An Efficient Overlapfree-Karatsuba Based Montgomery
Multiplier for Cryptographic Hardware

Montgomery Modular Multiplication (MMM) is one of the most
widely employed modules in cryptographic hardware due to its
ability to avoid costly division operations during modular reduc-
tion. In this work, an efficient Montgomery modular multiplication
architecture based on the Overlap-Free Karatsuba Algorithm (OKA)
is proposed in this work. The OKA technique restructures the mul-
tiplication process by eliminating overlapping terms and thereby
reduces the critical-path delay. Furthermore, optimized evaluation
and interpolation matrices are employed to simplify arithmetic
operations and eliminate subtraction operations. OKA lower multi-
plier has been used to compute modulo operation without doing
full multiplication. The proposed architecture demonstrates signif-
icant improvements in operational efficiency when implemented
on the Virtex-7 FPGA board. Experimental results indicate that
the proposed design achieves latency reductions of approximately
53.78%, 52.05%, 52.164%, 47.45%, 44.231% and 46.222% for operand
sizes of 32, 64, 128, 256, 512 and 1024 bits respectively, when com-
pared with existing state-of-the-art (SOTA) implementations. The
proposed design also achieves significant area reduction of approx-
imately 20.33%, 27.231%, 16.89%, 13.191%, 16.31% and 40.695% for
the corresponding operand sizes. In addition to the latency and
area improvements, the proposed design also achieves considerable
power savings of about 27.33%, 46.712%, 31.724%, 55.93%, 29.32% and
43.664% for the corresponding operand sizes. Similar performance
trends are observed in the ASIC implementation results which was
obtained using the OpenROAD design flow with the Nangate45
standard cell library.
