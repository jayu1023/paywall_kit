/// A single customer testimonial rendered by the storytelling variant.
class PaywallTestimonial {
  /// Creates a testimonial.
  const PaywallTestimonial({
    required this.quote,
    this.author,
    this.role,
  });

  /// The quote text.
  final String quote;

  /// Optional author name (e.g. `'Alex P.'`).
  final String? author;

  /// Optional author role (e.g. `'Indie developer'`).
  final String? role;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaywallTestimonial &&
          other.quote == quote &&
          other.author == author &&
          other.role == role;

  @override
  int get hashCode => Object.hash(quote, author, role);
}
