class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final bool isNew;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.sizes,
    required this.colors,
    this.isNew = false,
    this.isFavorite = false,
  });

  double? get discountPercent {
    if (originalPrice == null) return null;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
}

// Sample product data
final List<Product> sampleProducts = [
  const Product(
    id: '1',
    name: 'Silk Wrap Dress',
    brand: 'MAISON ÉLITE',
    price: 289.00,
    originalPrice: 420.00,
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
    category: 'Dresses',
    rating: 4.8,
    reviewCount: 124,
    description:
        'An exquisite silk wrap dress that drapes beautifully on the body. Perfect for evening events or upscale casual outings. The rich fabric catches light elegantly with every movement.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['#8B1A1A', '#1A1A2E', '#2D5A27'],
    isNew: true,
  ),
  const Product(
    id: '2',
    name: 'Structured Blazer',
    brand: 'VOGUE ATELIER',
    price: 345.00,
    imageUrl:
        'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&q=80',
    category: 'Tops',
    rating: 4.6,
    reviewCount: 89,
    description:
        'A power blazer with sharp tailoring and luxurious fabric. Features notched lapels and a perfectly structured silhouette that commands attention.',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['#2C2C2C', '#F5E6D3', '#4A3728'],
    isNew: false,
  ),
  const Product(
    id: '3',
    name: 'Leather Ankle Boot',
    brand: 'ROMAN CRAFT',
    price: 498.00,
    originalPrice: 620.00,
    imageUrl:
        'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=800&q=80',
    category: 'Shoes',
    rating: 4.9,
    reviewCount: 203,
    description:
        'Hand-crafted from supple Italian leather, these ankle boots feature a sleek silhouette and a comfortable block heel for all-day wear.',
    sizes: ['36', '37', '38', '39', '40', '41'],
    colors: ['#1C1C1C', '#8B6914', '#5C3317'],
    isNew: false,
  ),
  const Product(
    id: '4',
    name: 'Cashmere Turtleneck',
    brand: 'NORDIC LUXE',
    price: 176.00,
    imageUrl:
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&q=80',
    category: 'Tops',
    rating: 4.7,
    reviewCount: 156,
    description:
        'Spun from the finest Mongolian cashmere, this turtleneck is impossibly soft and provides luxurious warmth. A wardrobe essential.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['#F5E6D3', '#8B1A1A', '#2C2C2C', '#4A3728'],
    isNew: true,
  ),
  const Product(
    id: '5',
    name: 'Mini Shoulder Bag',
    brand: 'ARIA PARIS',
    price: 395.00,
    originalPrice: 520.00,
    imageUrl:
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80',
    category: 'Bags',
    rating: 4.5,
    reviewCount: 78,
    description:
        'A compact shoulder bag crafted from pebbled leather with a gold-tone chain strap. Fits all your essentials with iconic style.',
    sizes: ['One Size'],
    colors: ['#D4A0A0', '#1C1C1C', '#8B6914'],
    isNew: false,
  ),
  const Product(
    id: '6',
    name: 'Pleated Midi Skirt',
    brand: 'MAISON ÉLITE',
    price: 189.00,
    imageUrl:
        'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800&q=80',
    category: 'Dresses',
    rating: 4.6,
    reviewCount: 92,
    description:
        'A flowing pleated midi skirt in a fluid fabric that moves gracefully. The classic silhouette pairs beautifully with both casual and formal tops.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: ['#F5E6D3', '#2D5A27', '#8B1A1A'],
    isNew: true,
  ),
];
