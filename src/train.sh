#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --job-name=AugustTest

# The first phase: No local, no event

python main.py \
  --working-dir '../' \
  --saved_fn 'ttnet_1st_phase' \
  --num_epochs 50\
  --batch_size 32 \
  --num_workers 4 \
  --lr 0.001 \
  --lr_type 'step_lr' \
  --lr_step_size 10 \
  --lr_factor 0.1 \
  --gpu_idx 0 \
  --global_weight 5. \
  --seg_weight 1. \
  --no_local \
  --no_event \
  --smooth-labelling

# The second phase: Freeze the segmentation and the global modules

python main.py \
  --working-dir '../' \
  --saved_fn 'ttnet_2nd_phase' \
  --num_epochs 50\
  --batch_size 32 \
  --num_workers 10 \
  --lr 0.001 \
  --lr_type 'step_lr' \
  --lr_step_size 10 \
  --lr_factor 0.1 \
  --gpu_idx 0 \
  --global_weight 0. \
  --seg_weight 0. \
  --event_weight 2. \
  --local_weight 1. \
  --pretrained_path ../checkpoints/ttnet_1st_phase/ttnet_1st_phase_best.pth \
  --overwrite_global_2_local \
  --freeze_seg \
  --freeze_global \
  --smooth-labelling

# The third phase: Finetune all modules

python main.py \
  --working-dir '../' \
  --saved_fn 'ttnet_3rd_phase' \
  --num_epochs 30\
  --batch_size 32 \
  --num_workers 10 \
  --lr 0.0001 \
  --lr_type 'step_lr' \
  --lr_step_size 10 \
  --lr_factor 0.2 \
  --gpu_idx 0 \
  --global_weight 1. \
  --seg_weight 1. \
  --event_weight 1. \
  --local_weight 1. \
  --pretrained_path ../checkpoints/ttnet_2nd_phase/ttnet_2nd_phase_best.pth \
  --smooth-labelling