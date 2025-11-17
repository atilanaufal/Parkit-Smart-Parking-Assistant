# Client API Documentation

This document describes the public API endpoints that can be accessed without authentication. These endpoints are designed for end-users to view detection results.

## Base URL

```
http://localhost:8000
```

## Endpoints

### 1. Get Live Detection Results

Retrieve the most recent active detection session.

**Endpoint:** `GET /api/results/live`

**Authentication:** None required

**Response:**

```json
{
  "session_id": "abc-123-def-456",
  "camera_id": "parking-area-1",
  "status": "active",
  "max_detection_count": 15,
  "best_frame": {
    "frame_id": "frame-uuid",
    "timestamp": "2024-01-15T10:30:00Z",
    "detections": [
      {
        "bbox": {
          "x1": 100,
          "y1": 150,
          "x2": 200,
          "y2": 250
        },
        "confidence": 0.95,
        "assigned_row": 0,
        "row_y_coordinate": 100
      }
    ],
    "detection_count": 15,
    "empty_spaces": [
      {
        "space_id": "row0_space0",
        "row_index": 0,
        "x1": 200,
        "x2": 350,
        "y1": 50,
        "y2": 150,
        "width": 150.0,
        "can_fit_motorcycle": true
      }
    ],
    "total_motorcycles": 15,
    "total_empty_spaces": 5,
    "empty_spaces_per_row": {
      "0": 2,
      "1": 2,
      "2": 1
    },
    "parking_occupancy_rate": 75.0
  },
  "total_frames": 10
}
```

**Error Responses:**

- `404 Not Found`: No active detection session available

```json
{
  "detail": "No live detection available"
}
```

---

### 2. Get Specific Detection Result

Retrieve detection results for a specific session.

**Endpoint:** `GET /api/results/{session_id}`

**Authentication:** None required

**Parameters:**

- `session_id` (path parameter): The unique session identifier

**Response:**

```json
{
  "session_id": "abc-123-def-456",
  "camera_id": "parking-area-1",
  "status": "completed",
  "max_detection_count": 15,
  "best_frame": {
    "frame_id": "frame-uuid",
    "timestamp": "2024-01-15T10:30:00Z",
    "detections": [...],
    "detection_count": 15,
    "empty_spaces": [...],
    "total_motorcycles": 15,
    "total_empty_spaces": 5,
    "empty_spaces_per_row": {...},
    "parking_occupancy_rate": 75.0
  },
  "total_frames": 10
}
```

**Error Responses:**

- `404 Not Found`: Session not found

```json
{
  "detail": "Session not found"
}
```

---

### 3. Get Result Image

Retrieve the annotated image for a specific session with bounding boxes and empty space visualization.

**Endpoint:** `GET /api/results/{session_id}/image`

**Authentication:** None required

**Parameters:**

- `session_id` (path parameter): The unique session identifier

**Response:**

- Content-Type: `image/jpeg`
- Binary image data with:
  - Red bounding boxes around detected motorcycles
  - Green rectangles for empty parking spaces
  - Blue lines indicating parking row positions
  - Labels showing "EMPTY" on available spaces

**Error Responses:**

- `404 Not Found`: Session or image not found

```json
{
  "detail": "Image not found"
}
```

---

### 4. Get Latest Results

Retrieve a list of the most recent detection sessions.

**Endpoint:** `GET /api/results/latest`

**Authentication:** None required

**Query Parameters:**

- `limit` (optional, default: 10): Number of results to return (max: 100)
- `skip` (optional, default: 0): Number of results to skip for pagination

**Example Request:**

```
GET /api/results/latest?limit=20&skip=0
```

**Response:**

```json
{
  "results": [
    {
      "session_id": "abc-123",
      "camera_id": "parking-area-1",
      "status": "completed",
      "max_detection_count": 15,
      "total_frames": 10,
      "created_at": "2024-01-15T10:30:00Z"
    },
    {
      "session_id": "def-456",
      "camera_id": "parking-area-2",
      "status": "completed",
      "max_detection_count": 12,
      "total_frames": 8,
      "created_at": "2024-01-15T09:15:00Z"
    }
  ],
  "total": 2,
  "limit": 20,
  "skip": 0
}
```

---

## Data Models

### Detection Result

```typescript
{
  session_id: string;
  camera_id: string | null;
  status: "active" | "completed";
  max_detection_count: number;
  best_frame: BestFrame;
  total_frames: number;
}
```

### Best Frame

```typescript
{
  frame_id: string;
  timestamp: string; // ISO 8601 format
  detections: Detection[];
  detection_count: number;
  empty_spaces?: EmptySpace[]; // Only if calibration is active
  total_motorcycles?: number; // Only if calibration is active
  total_empty_spaces?: number; // Only if calibration is active
  empty_spaces_per_row?: { [row: string]: number }; // Only if calibration is active
  parking_occupancy_rate?: number; // Only if calibration is active
}
```

### Detection

```typescript
{
  bbox: {
    x1: number;
    y1: number;
    x2: number;
    y2: number;
  };
  confidence: number; // 0.0 to 1.0
  assigned_row?: number; // Only if calibration is active
  row_y_coordinate?: number; // Only if calibration is active
}
```

### Empty Space

```typescript
{
  space_id: string;
  row_index: number;
  x1: number;
  x2: number;
  y1: number;
  y2: number;
  width: number;
  can_fit_motorcycle: boolean;
}
```

---

## Error Handling

All endpoints return standard HTTP status codes:

- `200 OK`: Request successful
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error

Error responses follow this format:

```json
{
  "detail": "Error message description"
}
```

---

## Usage Examples

### JavaScript/Fetch

```javascript
// Get live detection
fetch('http://localhost:8000/api/results/live')
  .then(response => response.json())
  .then(data => {
    console.log('Live detection:', data);
    console.log('Total motorcycles:', data.best_frame.total_motorcycles);
    console.log('Empty spaces:', data.best_frame.total_empty_spaces);
  })
  .catch(error => console.error('Error:', error));

// Get specific result
const sessionId = 'abc-123-def-456';
fetch(`http://localhost:8000/api/results/${sessionId}`)
  .then(response => response.json())
  .then(data => console.log('Result:', data))
  .catch(error => console.error('Error:', error));

// Get result image
const imageUrl = `http://localhost:8000/api/results/${sessionId}/image`;
document.getElementById('result-image').src = imageUrl;

// Get latest results
fetch('http://localhost:8000/api/results/latest?limit=10')
  .then(response => response.json())
  .then(data => {
    console.log('Latest results:', data.results);
    console.log('Total count:', data.total);
  })
  .catch(error => console.error('Error:', error));
```

### Python/Requests

```python
import requests

# Get live detection
response = requests.get('http://localhost:8000/api/results/live')
if response.ok:
    data = response.json()
    print(f"Total motorcycles: {data['best_frame']['total_motorcycles']}")
    print(f"Empty spaces: {data['best_frame']['total_empty_spaces']}")
    print(f"Occupancy rate: {data['best_frame']['parking_occupancy_rate']}%")

# Get specific result
session_id = 'abc-123-def-456'
response = requests.get(f'http://localhost:8000/api/results/{session_id}')
result = response.json()

# Download result image
response = requests.get(f'http://localhost:8000/api/results/{session_id}/image')
with open('result.jpg', 'wb') as f:
    f.write(response.content)

# Get latest results
response = requests.get('http://localhost:8000/api/results/latest?limit=20')
data = response.json()
for result in data['results']:
    print(f"Session: {result['session_id']}, Detections: {result['max_detection_count']}")
```

### cURL

```bash
# Get live detection
curl http://localhost:8000/api/results/live

# Get specific result
curl http://localhost:8000/api/results/abc-123-def-456

# Download result image
curl http://localhost:8000/api/results/abc-123-def-456/image -o result.jpg

# Get latest results
curl "http://localhost:8000/api/results/latest?limit=10&skip=0"
```

---

## Notes

- All timestamps are in ISO 8601 format (UTC)
- Empty space detection is only available when camera calibration is configured
- The `best_frame` is automatically selected based on the highest detection count
- Images are served with appropriate caching headers for performance
- No rate limiting is applied to public endpoints
