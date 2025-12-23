#!/usr/bin/env python3
"""
Test GET /api/results/{session_id} endpoint
Output: JSON dengan posisi kosong per baris
"""

import requests
import json
import sys

# Configuration
BASE_URL = "https://overtame-dewitt-throbbingly.ngrok-free.dev"
API_KEY = "parkit-admin-best-UHUYYYYY"
HEADERS = {
    "X-API-Key": API_KEY,
    "ngrok-skip-browser-warning": "true"
}

def get_session_results(session_id):
    """Get results from endpoint and extract empty spaces per row"""
    
    print(f"\n{'='*60}")
    print(f"GET /api/results/{session_id}")
    print(f"{'='*60}")
    
    try:
        response = requests.get(
            f"{BASE_URL}/api/results/{session_id}",
            headers=HEADERS,
            timeout=30
        )
        
        if response.status_code != 200:
            print(f"❌ Error: {response.status_code}")
            print(f"Response: {response.text}")
            return None
        
        data = response.json()
        
        # Print raw response for debugging
        print("\n📥 RAW RESPONSE:")
        print(json.dumps(data, indent=2, default=str)[:2000])
        
        # Extract info - data bisa di level session atau di best_frame
        best_frame = data.get("best_frame", {}) or {}
        
        result = {
            "session_id": data.get("session_id"),
            "camera_id": data.get("camera_id"),
            "status": data.get("status"),
            "total_frames": data.get("total_frames", 0),
            "max_detection_count": data.get("max_detection_count", 0),
            # Cek di level session dulu, kalau tidak ada cek di best_frame
            "total_motorcycles": data.get("total_motorcycles") or best_frame.get("total_motorcycles") or data.get("max_detection_count", 0),
            "total_empty_spaces": data.get("total_empty_spaces") or best_frame.get("total_empty_spaces", 0),
            "parking_occupancy_rate": data.get("parking_occupancy_rate") or best_frame.get("parking_occupancy_rate", 0),
            "empty_spaces_per_row": data.get("empty_spaces_per_row") or best_frame.get("empty_spaces_per_row", {}),
        }
        
        # Detail posisi kosong per baris - cek di level session dan best_frame
        empty_spaces = data.get("empty_spaces") or best_frame.get("empty_spaces", []) or []
        spaces_by_row = {}
        
        for space in empty_spaces:
            row_idx = space.get("row_index", 0)
            row_key = f"row_{row_idx}"
            
            if row_key not in spaces_by_row:
                spaces_by_row[row_key] = []
            
            spaces_by_row[row_key].append({
                "space_id": space.get("space_id"),
                "x1": space.get("x1"),
                "x2": space.get("x2"),
                "y1": space.get("y1"),
                "y2": space.get("y2"),
                "width": space.get("width"),
                "can_fit_motorcycle": space.get("can_fit_motorcycle", False),
                "motorcycle_capacity": space.get("motorcycle_capacity", 0)
            })
        
        result["posisi_kosong_per_baris"] = spaces_by_row
        
        # Hitung motor per baris dari detections
        detections = best_frame.get("detections", [])
        result["total_detections"] = len(detections)
        
        # Coba ambil dari parking_analysis dulu
        parking_analysis = data.get("parking_analysis", {})
        motor_per_row = {}
        
        if parking_analysis and "detections" in parking_analysis:
            # Dari parking_analysis yang sudah ada assigned_row
            for det in parking_analysis.get("detections", []):
                row = det.get("assigned_row")
                if row is not None:
                    row_key = str(row)
                    motor_per_row[row_key] = motor_per_row.get(row_key, 0) + 1
        
        # Jika tidak ada, hitung dari motorcycles_per_row jika ada
        if not motor_per_row and parking_analysis:
            motor_per_row = {str(k): v for k, v in parking_analysis.get("motorcycles_per_row", {}).items()}
        
        # Jika masih kosong, coba dari best_frame detections dengan assigned_row
        if not motor_per_row:
            for det in detections:
                row = det.get("assigned_row")
                if row is not None:
                    row_key = str(row)
                    motor_per_row[row_key] = motor_per_row.get(row_key, 0) + 1
        
        result["motor_per_baris"] = motor_per_row
        result["parking_analysis_available"] = bool(parking_analysis)
        
        # Hitung kapasitas kosong per baris (dari motorcycle_capacity)
        kapasitas_kosong_per_row = {}
        for space in empty_spaces:
            row_idx = str(space.get("row_index", 0))
            capacity = space.get("motorcycle_capacity", 0)
            kapasitas_kosong_per_row[row_idx] = kapasitas_kosong_per_row.get(row_idx, 0) + capacity
        
        result["kapasitas_kosong_per_baris"] = kapasitas_kosong_per_row
        
        # Hitung total per baris (motor + kapasitas kosong)
        all_rows = set(motor_per_row.keys()) | set(kapasitas_kosong_per_row.keys())
        total_per_baris = {}
        for row in all_rows:
            motor = motor_per_row.get(row, 0)
            kosong = kapasitas_kosong_per_row.get(row, 0)  # Kapasitas, bukan jumlah area
            total_per_baris[row] = {
                "motor_terdeteksi": motor,
                "kapasitas_kosong": kosong,
                "total_slot": motor + kosong
            }
        
        result["total_per_baris"] = total_per_baris
        
        return result
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return None

def get_latest_session_id():
    """Get latest session ID from /api/admin/sessions"""
    try:
        response = requests.get(
            f"{BASE_URL}/api/admin/sessions?limit=1&skip=0",
            headers=HEADERS,
            timeout=10
        )
        
        print(f"   Status: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            sessions = data.get("sessions", [])
            if sessions:
                session = sessions[0]
                session_id = session.get("session_id")
                status = session.get("status")
                print(f"   Session: {session_id}")
                print(f"   Status: {status}")
                return session_id, status
        else:
            print(f"   Response: {response.text[:200]}")
        return None, None
    except Exception as e:
        print(f"   Error: {e}")
        return None, None

def complete_session(session_id):
    """Complete session to trigger empty space calculation"""
    print(f"\n⏳ Completing session {session_id}...")
    
    try:
        response = requests.post(
            f"{BASE_URL}/api/frames/complete/{session_id}",
            headers=HEADERS,
            timeout=120
        )
        
        if response.status_code == 200:
            result = response.json()
            print(f"✅ Session completed!")
            print(f"   Max Detections: {result.get('max_detection_count', 0)}")
            
            if 'best_frame' in result:
                frame = result['best_frame']
                print(f"   Empty Spaces: {frame.get('total_empty_spaces', 0)}")
                print(f"   Occupancy: {frame.get('parking_occupancy_rate', 0)}%")
            return True
        else:
            print(f"❌ Failed: {response.status_code}")
            print(f"   Response: {response.text[:300]}")
            return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

def main():
    # Get session_id from argument or use latest
    if len(sys.argv) > 1:
        session_id = sys.argv[1]
        status = None
    else:
        print("Mencari session terbaru...")
        session_id, status = get_latest_session_id()
        
        if not session_id:
            print("❌ Tidak ada session. Jalankan dengan: python test_results_endpoint.py <session_id>")
            return 1
        
        print(f"Menggunakan session terbaru: {session_id}")
        
        # Auto-complete if session is active
        if status == "active":
            print(f"\n⚠️ Session masih active, perlu di-complete untuk kalkulasi empty spaces")
            complete_session(session_id)
    
    # Get results
    result = get_session_results(session_id)
    
    if result:
        print("\n" + "="*60)
        print("📊 OUTPUT JSON - POSISI KOSONG PER BARIS")
        print("="*60)
        print(json.dumps(result, indent=2, ensure_ascii=False))
        
        # Save to file
        output_file = f"result_{session_id[:8]}.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(result, f, indent=2, ensure_ascii=False)
        print(f"\n✅ Saved to: {output_file}")
        
        # Summary
        print("\n" + "="*60)
        print("📋 SUMMARY")
        print("="*60)
        print(f"Session: {result['session_id']}")
        print(f"Camera: {result['camera_id']}")
        print(f"Status: {result['status']}")
        print(f"Total Detections: {result.get('total_detections', 0)}")
        print(f"Total Motor: {result.get('total_motorcycles', 0)}")
        print(f"Total Ruang Kosong: {result.get('total_empty_spaces', 0)}")
        print(f"Occupancy Rate: {result.get('parking_occupancy_rate', 0)}%")
        
        # Total per baris (motor + kapasitas kosong)
        print("\n" + "="*60)
        print("📊 TOTAL PER BARIS (Motor + Kapasitas Kosong)")
        print("="*60)
        total_per_baris = result.get('total_per_baris', {})
        if total_per_baris:
            print(f"   {'Baris':<10} {'Motor':<12} {'Kap.Kosong':<12} {'Total Slot':<10}")
            print(f"   {'-'*44}")
            for row in sorted(total_per_baris.keys(), key=lambda x: int(x) if x.isdigit() else 0):
                data = total_per_baris[row]
                print(f"   Row {row:<6} {data['motor_terdeteksi']:<12} {data['kapasitas_kosong']:<12} {data['total_slot']:<10}")
            
            # Total keseluruhan
            total_motor = sum(d['motor_terdeteksi'] for d in total_per_baris.values())
            total_kosong = sum(d['kapasitas_kosong'] for d in total_per_baris.values())
            total_slot = sum(d['total_slot'] for d in total_per_baris.values())
            print(f"   {'-'*44}")
            print(f"   {'TOTAL':<10} {total_motor:<12} {total_kosong:<12} {total_slot:<10}")
        else:
            print("   (Tidak ada data per baris)")
        
        # Detail posisi per baris
        print("\n" + "="*60)
        print("📍 DETAIL POSISI KOSONG PER BARIS")
        print("="*60)
        posisi_per_baris = result.get('posisi_kosong_per_baris', {})
        if posisi_per_baris:
            total_capacity = 0
            for row_key in sorted(posisi_per_baris.keys()):
                spaces = posisi_per_baris[row_key]
                row_capacity = sum(s.get('motorcycle_capacity', 0) for s in spaces)
                total_capacity += row_capacity
                print(f"\n   {row_key.upper()} ({len(spaces)} area kosong, kapasitas: {row_capacity} motor):")
                for i, space in enumerate(spaces, 1):
                    capacity = space.get('motorcycle_capacity', 0)
                    print(f"      {i}. ID: {space['space_id']}")
                    print(f"         Posisi X: {space['x1']:.0f} - {space['x2']:.0f}")
                    print(f"         Lebar: {space['width']:.0f}px")
                    print(f"         Kapasitas: {capacity} motor")
            print(f"\n   TOTAL KAPASITAS KOSONG: {total_capacity} motor")
        else:
            print("   (Tidak ada detail posisi kosong)")
        
        return 0
    
    return 1

if __name__ == "__main__":
    sys.exit(main())
