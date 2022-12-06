#!/bin/bash
GPU_NUM=6
GPU_COUNT=1
NAME='lm_rgb_noSyn_crop'
WANDB_PROJ='pose_estimation'
export CUDA_VISIBLE_DEVICES=$GPU_NUM
CLS='phone'
EXP_DIR='/workspace/REPO/pose_estimation/ffb6d/train_log'
LOG_EVAL_DIR="$EXP_DIR/$NAME/$CLS/eval_results"
SAVE_CHECKPOINT="$EXP_DIR/$NAME/$CLS/checkpoints"
LOG_TRAININFO_DIR="$EXP_DIR/$NAME/$CLS/train_info"
# checkpoint to resume. 
#tst_mdl="train_log/linemod_half_pseang_1/checkpoints/${cls}/FFB6D_${cls}_best.pth.tar"
python -m torch.distributed.launch --nproc_per_node=$GPU_COUNT --master_port 60000 apps/train_lm_rgb_crop.py \
    --gpus=$GPU_COUNT \
    --wandb_proj $WANDB_PROJ \
    --wandb_name $NAME \
    --num_threads 0 \
    --dataset_name 'linemod' \
    --data_root '/workspace/DATA/Linemod_preprocessed' \
    --train_list 'train.txt' --test_list 'test.txt' \
    --linemod_cls=$CLS \
    --n_total_epoch 30 \
    --lm_no_fuse --lm_no_render \
    --rgb_only \
    --crop --width 320 --height 240 --n_sample_points 6400 --max_w 320 --max_h 240 \
    --log_eval_dir $LOG_EVAL_DIR --save_checkpoint $SAVE_CHECKPOINT --log_traininfo_dir $LOG_TRAININFO_DIR \