import os
import sys
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

def create_qr_icon():
    # Create a new white image with 1024x1024 dimensions
    img = Image.new('RGB', (1024, 1024), color=(255, 255, 255))
    draw = ImageDraw.Draw(img)
    
    # Add dark blue background circle
    draw.ellipse([100, 100, 924, 924], fill='#1E40AF')
    
    # Add lighter blue inner circle
    draw.ellipse([200, 200, 824, 824], fill='#3B82F6')
    
    # Add white inner circle
    draw.ellipse([300, 300, 724, 724], fill='white')
    
    # Add main QR symbol (simplified representation)
    # QR corners
    for corner in [(350, 350), (674, 350), (350, 674)]:
        x, y = corner
        draw.rectangle([x, y, x + 120, y + 120], fill='#1E40AF')
        draw.rectangle([x + 20, y + 20, x + 100, y + 100], fill='white')
        draw.rectangle([x + 35, y + 35, x + 85, y + 85], fill='#1E40AF')
    
    # QR body pattern
    for i in range(12):
        for j in range(12):
            if (i + j) % 2 == 0 and i not in (0, 1, 2, 3, 11, 10, 9, 8) and j not in (0, 1, 2, 3, 11, 10, 9, 8):
                x = 420 + i * 25
                y = 420 + j * 25
                draw.rectangle([x, y, x + 20, y + 20], fill='#1E40AF')
    
    # Add "QR" text
    try:
        # Try to use a system font
        if sys.platform == 'win32':
            font = ImageFont.truetype('arial.ttf', 180)
        elif sys.platform == 'darwin':
            font = ImageFont.truetype('Arial.ttf', 180)
        else:
            font = ImageFont.truetype('DejaVuSans-Bold.ttf', 180)
        
        # Draw "QR" text
        text = "QR"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (1024 - text_width) // 2
        y = (1024 - text_height) // 2
        draw.text((x, y), text, fill='#1E40AF', font=font)
        
        # Add "O5DE" subtitle
        if sys.platform == 'win32':
            font = ImageFont.truetype('arial.ttf', 120)
        elif sys.platform == 'darwin':
            font = ImageFont.truetype('Arial.ttf', 120)
        else:
            font = ImageFont.truetype('DejaVuSans-Bold.ttf', 120)
        
        text = "O5DE"
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_height = bbox[3] - bbox[1]
        x = (1024 - text_width) // 2
        y = (1024 - text_height) // 2 + 200
        draw.text((x, y), text, fill='#3B82F6', font=font)
        
    except IOError:
        print("Warning: Could not find font, using basic text")
        # Fallback to basic text if font not found
        draw.text((300, 350), "QR", fill='#1E40AF', font=None, size=180)
        draw.text((300, 550), "O5DE", fill='#3B82F6', font=None, size=120)
    
    # Create assets directory if it doesn't exist
    assets_dir = os.path.join(os.getcwd(), 'assets', 'images')
    os.makedirs(assets_dir, exist_ok=True)
    
    # Save the generated icon
    icon_path = os.path.join(assets_dir, 'app_icon.png')
    img.save(icon_path, 'PNG')
    print(f"QR icon saved to {icon_path}")
    
    return img

if __name__ == "__main__":
    print("Generating QR icon...")
    create_qr_icon()
