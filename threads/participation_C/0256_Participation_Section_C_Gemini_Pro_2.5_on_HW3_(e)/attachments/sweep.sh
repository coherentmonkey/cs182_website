#!/bin/bash

# This script automates the hyperparameter sweep, demonstrating how a command-line
# interface enables robust, repeatable experimentation.

echo "Starting Adam Sweep..."
ADAM_LRS=(0.0001 0.0003 0.001 0.003 0.01 0.03 0.1)
WIDTHS=(16 32 64 128 256)

for width in "${WIDTHS[@]}"; do
  for lr in "${ADAM_LRS[@]}"; do
    echo "Running Adam with width=${width} and lr=${lr}"
    python run_experiment.py --optimizer adam --width "$width" --lr "$lr" --log-dir "results/adam" --checkpoint-dir "checkpoints/adam"
  done
done

echo "Starting muP Sweep..."
MUP_LRS=(0.03 0.1 0.3 1.0 3.0)

for width in "${WIDTHS[@]}"; do
  for lr in "${MUP_LRS[@]}"; do
    echo "Running muP with width=${width} and lr=${lr}"
    python run_experiment.py --optimizer mup --width "$width" --lr "$lr" --log-dir "results/mup" --checkpoint-dir "checkpoints/mup"
  done
done

echo "Sweep complete. Check the 'results/' directory."

# You can then write a separate Python script to read 'results/adam/results.csv'
# and 'results/mup/results.csv' to generate the final plots.