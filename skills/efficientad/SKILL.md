---
name: efficientad
description: >
  Anomaly detection patterns using EfficientAD for industrial quality control and visual inspection.
  Trigger: When implementing anomaly detection models using EfficientAD.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Implementing anomaly detection models using EfficientAD"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## When to Use

Use this skill when:
- Detecting anomalies in images where only "normal" data is available for training.
- Performing visual quality inspection in industrial environments (MVTec AD dataset style).
- Requiring high-speed inference for anomaly detection (SOTA speed/accuracy trade-off).
- Generating anomaly maps (heatmaps) to localize defects.

---

## Critical Patterns

### Pattern 1: Student-Teacher Architecture
EfficientAD uses a pre-trained Teacher and a Student network that mimics the teacher on normal data. Anomalies are detected when the Student fails to mimic the Teacher.

```python
# Conceptual architecture setup
from models.efficientad import EfficientAD

model = EfficientAD(
    dataset_path='data/mvtec/capsule',
    teacher_out_channels=384,
    model_size='S' # Small or Medium
)
```

### Pattern 2: Normalization & Map Generation
Anomaly scores must be normalized using the statistics of the normal training data to provide a consistent threshold.

```python
# Inference and map generation
anomaly_map, score = model.predict(image)
threshold = 0.5  # Determined during validation on normal data
is_anomalous = score > threshold
```

---

## Decision Tree

```
Training data available? -> Train Student-Teacher on normal samples
Fast inference needed?  -> Use EfficientAD-S (Small)
Detailed defect localization? -> Analyze the generated Anomaly Map (heatmap)
```

---

## Code Examples

### Example 1: Training Setup
Training EfficientAD requires a dataset of only "good" samples.

```python
# training script snippet
from torch.utils.data import DataLoader
from dataset import MVTecDataset

train_set = MVTecDataset(root='data/capsule', category='capsule', is_train=True)
train_loader = DataLoader(train_set, batch_size=1, shuffle=True)

# Training loop focuses on minimizing student-teacher discrepancy
for img in train_loader:
    loss = model.training_step(img)
    loss.backward()
    optimizer.step()
```

### Example 2: Inference with Heatmap
Visualizing the detected anomaly.

```python
import matplotlib.pyplot as plt

image = load_image('test_sample.png')
anomaly_map, score = model.predict(image)

plt.imshow(image)
plt.imshow(anomaly_map, cmap='jet', alpha=0.5) # Overlay heatmap
plt.title(f"Anomaly Score: {score:.4f}")
plt.show()
```

---

## Commands

```bash
python train.py --dataset capsule --model_size S  # Train EfficientAD Small
python test.py --checkpoint best.ckpt             # Run evaluation
pip install -r requirements_efficientad.txt       # Install dependencies
```

---

## Resources

- **Paper**: [EfficientAD: Accurate Visual Anomaly Detection at High Speed](https://arxiv.org/abs/2303.14535)
- **Repo**: [Official EfficientAD Implementation](https://github.com/nelson-liu/EfficientAD)
