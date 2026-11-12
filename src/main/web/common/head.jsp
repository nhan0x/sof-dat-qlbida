<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<script>
    tailwind.config = {
        darkMode: 'class',
        theme: {
            extend: {
                fontFamily: {
                    classic: ['"Playfair Display"', 'serif'],
                    body: ['"Inter"', 'sans-serif'],
                },
                colors: {
                    felt: {
                        light: '#2a7a4d', // Xanh mặt nỉ sáng
                        dark: '#0f3622',  // Xanh mặt nỉ trong bóng tối
                    },
                    wood: {
                        light: '#6d4c41',
                        base: '#3e2723',
                        dark: '#1e110a',
                    },
                    gold: {
                        light: '#f9e596',
                        base: '#d4af37', // Vàng đồng
                        dark: '#997a15',
                    }
                },
                animation: {
                    'roll': 'roll 0.8s cubic-bezier(0.25, 1, 0.5, 1) forwards',
                },
                keyframes: {
                    roll: {
                        '0%': { transform: 'rotate(0deg) translateX(0)' },
                        '100%': { transform: 'rotate(360deg) translateX(0)' }
                    }
                }
            }
        }
    }
</script>

<style>
    body {
        font-family: 'Inter', sans-serif;
    }

    /* SVG Noise filter tạo vân vải nỉ chân thực */
    .bg-billiards-felt {
        background-color: #2a7a4d;
        background-image: radial-gradient(circle at 50% 0%, rgba(255,255,255,0.15) 0%, transparent 70%),
        url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.15'/%3E%3C/svg%3E");
    }

    .dark .bg-billiards-felt {
        background-color: #0c2617;
        background-image: radial-gradient(circle at 50% -20%, rgba(212, 175, 55, 0.15) 0%, transparent 60%),
        url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' opacity='0.1'/%3E%3C/svg%3E");
    }

    /* Khung viền mô phỏng thành băng bàn bida bằng gỗ */
    .wood-frame {
        background: linear-gradient(135deg, #4e342e 0%, #3e2723 50%, #26140e 100%);
        box-shadow:
                0 25px 50px -12px rgba(0, 0, 0, 0.8),
                inset 0 0 0 2px rgba(255,255,255,0.05),
                inset 0 0 15px rgba(0,0,0,0.9);
    }

    /* Mặt trong của form (lõm xuống) */
    .inner-felt {
        background-color: rgba(20, 60, 35, 0.95);
        box-shadow: inset 0 5px 20px rgba(0,0,0,0.5);
        border: 1px solid rgba(212, 175, 55, 0.2);
    }
    .dark .inner-felt {
        background-color: rgba(6, 20, 12, 0.95);
        box-shadow: inset 0 5px 30px rgba(0,0,0,0.8);
        border: 1px solid rgba(212, 175, 55, 0.1);
    }

    /* Chữ viền vàng kim */
    .gold-text-emboss {
        background: linear-gradient(to bottom, #f9e596 0%, #d4af37 60%, #997a15 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        filter: drop-shadow(0 2px 4px rgba(0,0,0,0.5));
    }

    /* Input Autofill fix */
    input:-webkit-autofill {
        -webkit-box-shadow: 0 0 0 30px #1c452c inset !important;
        -webkit-text-fill-color: #e5e7eb !important;
        transition: background-color 5000s ease-in-out 0s;
    }
    .dark input:-webkit-autofill {
        -webkit-box-shadow: 0 0 0 30px #0a1f13 inset !important;
        -webkit-text-fill-color: #d4af37 !important;
    }

    /* Scrollbar */
    ::-webkit-scrollbar {
        width: 6px;
        height: 6px;
    }
    ::-webkit-scrollbar-track {
        background: rgba(0,0,0,0.1);
    }
    ::-webkit-scrollbar-thumb {
        background: rgba(212, 175, 55, 0.3);
        border-radius: 3px;
    }
    ::-webkit-scrollbar-thumb:hover {
        background: rgba(212, 175, 55, 0.5);
    }
</style>
