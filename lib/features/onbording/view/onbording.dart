import 'package:flutter/material.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  
  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/images/o1.png',
      title: 'Test Before You Invest',
      description:
          'Never commit to full sized purchases blindfolded. Discover authentic miniatures curated for your taste',
    ),
    OnboardingModel(
      image: 'assets/images/o2.png',
      title: 'Small Sizes, Big Decisions',
      description:
          'Pick sample sizes tailored to your space, skin, or style. Compare options freely in your own environment.',
    ),
    OnboardingModel(
      image: 'assets/images/o3.png',
      title: 'Love It? Claim The Full Size',
      description:
          'Track your favorites and purchase certified full sized originals with a single tap, risk-free.',
    ),
  ];

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

                itemBuilder: (context, index) {
  final page = _pages[index];
  return Column(
    children: [
      const SizedBox(height: 100,),
    
      Expanded(
        flex: 6,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            page.image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover, 
            alignment: Alignment.center,
          ),
        ),
      ),
      
      Expanded(
        flex: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1B1B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Color(0xFF7A7A7A),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
},
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFAAAAAA),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3.5),
                        height: 9,
                        width: _currentIndex == index ? 33 : 9,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? const Color(0xFFC86D51)
                              : const Color(0xFF2B2B2B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  
                  GestureDetector(
                    onTap: () {
                      if (_currentIndex == _pages.length - 1) {
                        _navigateToLogin();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Text(
                      _currentIndex == _pages.length - 1 ? 'Start' : 'Next',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF1B1B1B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                
                ],
                
              ),
            ),
              const SizedBox(height:25),
          ],
        ),
      ),
    );
  }
}