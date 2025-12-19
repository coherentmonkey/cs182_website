Summary

For this participation I used the modern LLM listed in `model.txt` (GPT 5.1) on the coding parts of HW7, specifically the four notebooks `q_rnn_and_grad.ipynb`, `q_rnn_last_name.ipynb`, `q_autoencoder.ipynb`, and `q_graph_clustering.ipynb`. The full interaction log is in `CHAT.md`; this writeup is my own reflection on how well the model handled the coding tasks, where it needed help, and what kinds of mistakes or “hallucinations” showed up. Overall, the model was able to one‑shot most of the coding TODOs so that cells ran and tests passed on the first try, with a few spots (mainly in the autoencoder notebook and device handling) that required back‑and‑forth fixes.


What I asked the model to do

I started by asking the model to read the participation instructions and scan all four notebooks to understand the TODOs. Then I used it as a coding assistant for:
- Question 1 (RNNs and gradients) in `q_rnn_and_grad.ipynb`: implement a vanilla RNN layer, a simple regression model on top, the loss function that can switch between “all‑timesteps” and “last‑timestep‑only”, and the gradient visualization / multi‑layer RNN pieces.
- Question 2 coding in `q_rnn_last_name.ipynb`: implement the character‑level `RecurrentClassifier` (embedding, RNN/LSTM stack, forward method using the last non‑pad position), `letterToIndex`, and pick training hyperparameters that get ≥80% accuracy by epoch 20, plus a small cell to classify my last name.
- The autoencoder question in `q_autoencoder.ipynb`: implement the vanilla autoencoder (encoder/decoder/forward/loss), the denoising and masked autoencoders, the linear probe evaluation code, the plotting helper for the synthetic experiments, and then define a nonlinear MNIST autoencoder and hyperparameters that get good linear‑probe accuracy.
- The spectral clustering question in `q_graph_clustering.ipynb`: implement the RBF adjacency matrix, the inverse square‑root degree matrix, the normalized matrix \(M = D^{-1/2} A D^{-1/2}\), convert it to a stochastic matrix, and then do SVD + KMeans for spectral clustering.

I also asked the model to help with some practical issues that came up while running the notebooks locally, like replacing `.cuda()` calls with device‑agnostic `.to(device)` and adding special handling for Apple’s MPS backend.


How often it one‑shotted the code

For most of the TODOs the model produced working code in one shot, in the sense that the notebook cell ran and the provided tests passed without any edits from me. That was true for:
- The core RNN pieces in `q_rnn_and_grad.ipynb` (RNNLayer, RecurrentRegressionModel, loss function, gradient visualizer logic, and the multi‑layer RNN).
- Almost all of `q_rnn_last_name.ipynb` (the classifier architecture, forward method using `last_pos`, `letterToIndex`, and the training hyperparameters).
- The graph clustering notebook: adjacency matrix, degree matrix, normalized matrix, stochastic conversion, and the helper that computes the top singular vectors and runs KMeans.

Where I did need follow‑ups, it was usually because the model had matched the assignment “spirit” but not the exact implementation that the autograder expected. The most back‑and‑forth happened in the autoencoder notebook: first getting the decoder architecture and loss normalization exactly right, then fixing how the linear probe accuracy function counted samples, and then dealing with CUDA vs CPU/MPS device issues. Even there, each individual fix was straightforward for the model once I pasted the assertion error or traceback.

I also didn’t have to debug low‑level PyTorch errors very much. The shapes, broadcasting, and device moves were almost always right on the first attempt. When there were errors (for example, trying to call `.cuda()` on a non‑CUDA build), they were due to environment assumptions, not incorrect tensor math.


Notable mistakes and corrections

The closest things to “hallucinations” here were places where the model filled in a reasonable‑looking implementation that didn’t quite match the homework’s hidden reference solution or my actual hardware:

1. Autoencoder loss definition  
Initially the model used `F.mse_loss` with its default reduction, which averages over all elements (batch × features). The test cell expected a different normalization that sums squared error over features for each sample and then averages over the batch. This made the numeric value off by roughly a factor equal to the input dimension. Once I showed the failing assertion and the expected scalar, the model corrected the loss to match the formula in the writeup. This wasn’t a random hallucination; it was more like choosing a standard loss default that didn’t match the autograder’s convention.

2. Autoencoder linear probe accuracy  
In `Experiment._get_model_accuracy`, the first version double‑counted or miscounted the total number of samples, so the reported accuracy didn’t line up with the target 53.00% in the test cell. After I ran the code and pasted the assertion, the model fixed the loop so `num_samples` was counted cleanly and the accuracy matched the reference. Again, the bug was small bookkeeping detail, not a completely made‑up algorithm.

3. Denoising and masked autoencoders  
For the denoising autoencoder the model first wrote the forward pass manually using `encode`/`decode`, then later switched to calling `self(x_noisy)` to align with the intended interface. For the masked autoencoder it originally tried to implement a custom masked loss over only unmasked entries, which is conceptually reasonable, but that didn’t match what the tests were checking. After seeing assertion failures it simplified the training step to use the base loss against the original `x`, which made the provided tests pass. In both cases the model’s first idea was still “sensible,” just not what this particular notebook wanted.

4. Device handling (CUDA vs MPS/CPU)  
The original notebook code assumed CUDA and called `.cuda()` in several places (model, tensors, and linear probes). On my machine PyTorch was built without CUDA, and I’m on a Mac with MPS support. The model responded by introducing a `device` variable that prefers CUDA, then MPS, then CPU, and then systematically replaced `.cuda()` with `.to(device)` throughout the `Experiment` class and the test cells. There was some iteration here as well (e.g., making sure seeding didn’t unconditionally call `torch.cuda.manual_seed`), but the corrections were all consistent and worked once I re‑ran the notebook from the top.

5. Slightly over‑fancy explanations  
In a couple of places (especially in the graph clustering written answers inside CHAT.md) the model gave fairly polished explanations of why spectral clustering works, what the normalized matrix represents, etc. These weren’t wrong, but they were more verbose than I would naturally write on my own. For the code itself, though, it mostly stuck to straightforward implementations that passed the tests.

I did not see any cases where the model invented completely bogus APIs or mathematical formulas for these coding problems. The mistakes were all in small implementation details and environment assumptions.


Behavior across the different notebooks

Across all four notebooks, the pattern I noticed was:
- It is very good at filling in medium‑sized PyTorch classes from a short textual description and a function docstring, especially when the skeleton code already lays out the method signatures and comments.
- It respects shapes and batch/time dimensions, and it correctly used tools like `gather` for the last‑timestep logic in the name classifier without me having to push it.
- When there was a mismatch with the tests, it responded well to a single assertion message or traceback and could usually fix the code in one more iteration.
- It also handled the “plumbing” changes (device selection, seeding, `.to(device)`) cleanly once I told it about the environment error.

Because most of the interaction was me pasting in TODO blocks and tests and then having the model fill in the missing code, there actually weren’t many deep “conceptual” hallucinations to catch. The autograders in the notebooks acted as a sanity check: if the code compiled and all the asserts passed, there wasn’t much ambiguity about whether the implementation was correct.


Overall takeaways

Compared to my earlier participation where I used GPT 5.1 on theory questions, this time I used it on fairly practical coding tasks with a lot of PyTorch plumbing. My impression is that the model is at least as strong here: it can implement full RNNs, autoencoders, and spectral clustering pipelines in a single pass that usually passes the tests immediately. The places where it failed were mostly about matching exact numeric conventions (how to average the loss) or environment details (assuming CUDA).

For this homework, if I hadn’t been forced to check against the tests and read the errors, it would have been easy to just accept the first code it wrote. The main lesson for me is similar to last time: the model can do most of the heavy lifting on these coding tasks, but I still need to run the cells, look carefully at assertion failures, and sometimes nudge it back toward exactly what the assignment expects. In other words, it feels less like “the model is doing something magical” and more like I have a very fast partner who writes the first draft of the code, and my job is to make sure that draft really matches the spec.


