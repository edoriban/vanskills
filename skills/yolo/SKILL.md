---
name: yolo
description: >
  Computer vision patterns for object detection, segmentation, and classification using YOLO (Ultralytics).
  Trigger: When implementing computer vision models using YOLO.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Implementing computer vision models using YOLO"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## When to Use

Use this skill when:
- Performing object detection, instance segmentation, or image classification.
- Training custom YOLO models on specialized datasets.
- Running real-time inference on video streams or images.
- Optimizing YOLO models for edge devices (Exporting to ONNX, TensorRT, etc.).

---

## Critical Patterns

### Pattern 1: Ultralytics API
Always use the modern `ultralytics` package for YOLOv8/v9/v10/v11.

```python
from ultralytics import YOLO

# Load a model (pre-trained or custom)
model = YOLO("yolo11n.pt") 

# Train the model
results = model.train(data="dataset.yaml", epochs=100, imgsz=640)
```

### Pattern 2: Result Handling
Properly iterate through inference results to extract bounding boxes, classes, and confidence scores.

```python
results = model("image.jpg")

for result in results:
    boxes = result.boxes
    for box in boxes:
        x1, y1, x2, y2 = box.xyxy[0]  # get box coordinates in (top, left, bottom, right) format
        conf = box.conf[0]           # confidence score
        cls = box.cls[0]             # class index
```

---

## Decision Tree

```
Real-time on edge? -> Use YOLO Nano (n) version and export to TensorRT/OpenVINO
High accuracy needed? -> Use YOLO Large (l) or Extra Large (x) versions
Counting objects? -> Use Object Detection
Isolating shapes? -> Use Instance Segmentation
```

---

## Code Examples

### Example 1: Custom Training Configuration
Creating a `dataset.yaml` and launching training.

```yaml
# dataset.yaml
path: ../datasets/my_data
train: images/train
val: images/val

names:
  0: person
  1: helmet
```

### Example 2: Inference with Persistence
Handling video streams with tracking.

```python
import cv2
from ultralytics import YOLO

model = YOLO("yolo11n.pt")
cap = cv2.VideoCapture("video.mp4")

while cap.isOpened():
    success, frame = cap.read()
    if success:
        # Run YOLO tracking on the frame, persisting tracks between frames
        results = model.track(frame, persist=True)
        annotated_frame = results[0].plot()
        cv2.imshow("YOLO Tracking", annotated_frame)
    else:
        break
```

---

## Commands

```bash
yolo task=detect mode=train data=data.yaml model=yolo11n.pt epochs=100  # CLI Training
yolo task=detect mode=predict model=best.pt source='video.mp4'         # CLI Inference
pip install ultralytics                                                # Install YOLO
```

---

## Resources

- **Docs**: [Ultralytics Documentation](https://docs.ultralytics.com/)
- **Hub**: [Ultralytics Hub](https://hub.ultralytics.com/)
