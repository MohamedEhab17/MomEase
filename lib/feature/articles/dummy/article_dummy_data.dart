import 'package:new_mama/feature/articles/data/models/article_model.dart';

final List<ArticleModel> dummyArticles = [
  ArticleModel(
    id: '1',
    category: 'Mental Health',
    title: 'Why Support Matters',
    authorName: 'Dr. Sarah Jenkins',
    authorImageUrl: 'https://i.pravatar.cc/150?img=1',
    date: 'Dec 12, 2024',
    readTime: '14 mins',
    imageUrl:
        'https://images.unsplash.com/photo-1555252333-9f8e92e65df9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    overview:
        'New motherhood can feel isolating. Having a support network reduces risk of postpartum depression, provides practical help, and offers emotional validation.',
    sections: [
      ArticleSection(heading: 'Finding Your People', content: null),
      ArticleSection(
        heading: 'Local Groups',
        bulletPoints: [
          'New parent classes at hospitals',
          'Library story times',
          'Mommy-and-me fitness classes',
          'Breastfeeding support groups',
          'Postpartum support groups',
        ],
      ),
      ArticleSection(
        heading: 'Online Communities',
        bulletPoints: [
          'Due date groups on social media',
          'Local parenting Facebook groups',
          'Apps for meeting parent friends',
          'Virtual support groups',
        ],
      ),
      ArticleSection(
        heading: 'Building Meaningful Connections',
        content:
            "**Be Vulnerable**: Share your real experiences, not just highlight reel. **Reach Out First**: Others are probably feeling isolated too. **Regular Meet-ups**: Consistency builds deeper friendships. **Support Others**: Friendship is a two-way street. **Be Patient**: Deep friendships take time to develop.",
      ),
      ArticleSection(
        heading: 'Different Types of Support',
        content:
            "**Practical Help**: Someone to hold baby while you shower, meal trains, or help with older children.\n\n**Emotional Support**: Non-judgmental listening, validation of feelings, and sharing experiences.",
      ),
      ArticleSection(
        heading: 'When You Don\'t Have Local Support',
        bulletPoints: [
          'Join online communities',
          'Schedule regular video calls with distant friends/family',
          'Hire help when possible',
          'Be extra kind to yourself',
          'Know that this phase is temporary',
        ],
      ),
    ],
  ),
  ArticleModel(
    id: '2',
    category: 'Nutrition',
    title: 'Nourishing Your Body Postpartum',
    authorName: 'Emma Watson',
    authorImageUrl: 'https://i.pravatar.cc/150?img=2',
    date: 'Jan 05, 2025',
    readTime: '8 mins',
    imageUrl:
        'https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    overview:
        'Learn how to fuel your recovery and maintain energy while caring for your newborn.',
    sections: [
      ArticleSection(
        heading: 'Focus on Hydration',
        content:
            'Drinking enough water is extremely important, especially if you are breastfeeding.',
      ),
      ArticleSection(
        heading: 'Easy Snacks',
        bulletPoints: [
          'Almonds and walnuts',
          'Greek yogurt with berries',
          'Hard-boiled eggs',
        ],
      ),
    ],
  ),
  ArticleModel(
    id: '3',
    category: 'Baby Care',
    title: 'Understanding Baby Sleep Cycles',
    authorName: 'Sarah Smith',
    authorImageUrl: 'https://i.pravatar.cc/150?img=3',
    date: 'Feb 10, 2025',
    readTime: '10 mins',
    imageUrl:
        'https://images.unsplash.com/photo-1544126592-807ade215a0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    overview:
        'Newborn sleep patterns can be confusing. Learn what to expect and how to help your baby establish healthy sleep habits.',
    sections: [
      ArticleSection(
        heading: 'The First Three Months',
        content:
            'Newborns don\'t have a circadian rhythm yet. They sleep around the clock in short bursts.',
      ),
      ArticleSection(
        heading: 'Sleep Cues',
        bulletPoints: [
          'Rubbing eyes',
          'Yawning',
          'Looking away or losing interest',
          'Fussiness',
        ],
      ),
      ArticleSection(
        heading: 'Creating a Sleep Environment',
        content:
            'A dark, cool, and quiet room with white noise can significantly improve sleep quality. Swaddling can also mimic the womb environment.',
      ),
    ],
  ),
  ArticleModel(
    id: '4',
    category: 'Development',
    title: 'Milestones: The First 6 Months',
    authorName: 'Dr. Emily Chen',
    authorImageUrl: 'https://i.pravatar.cc/150?img=4',
    date: 'Mar 01, 2025',
    readTime: '12 mins',
    imageUrl:
        'https://images.unsplash.com/photo-1519689680058-324335c77eba?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    overview:
        'Track your baby\'s incredible growth during their first half-year, from first smiles to rolling over.',
    sections: [
      ArticleSection(
        heading: 'Month 1-2: Awakening',
        content:
            'Your baby starts making eye contact, recognizing your face, and might show their first social smile.',
      ),
      ArticleSection(
        heading: 'Month 3-4: Movement',
        bulletPoints: [
          'Gaining head control',
          'Reaching for objects',
          'Babbling and cooing',
        ],
      ),
      ArticleSection(
        heading: 'Month 5-6: Exploration',
        content:
            'Rolling over usually begins. They might also start sitting with support and showing interest in solid foods.',
      ),
    ],
  ),
  ArticleModel(
    id: '5',
    category: 'Postpartum',
    title: 'Navigating Physical Recovery',
    authorName: 'Nurse Jackie',
    authorImageUrl: 'https://i.pravatar.cc/150?img=5',
    date: 'Mar 12, 2025',
    readTime: '15 mins',
    imageUrl:
        'https://images.unsplash.com/photo-1550989460-0adf9ea622e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    overview:
        'A comprehensive guide to what your body goes through after birth and how to gently heal.',
    sections: [
      ArticleSection(
        heading: 'The Fourth Trimester',
        content:
            'The first 12 weeks postpartum are crucial. Your body is recovering from a major event while also adapting to caring for a newborn.',
      ),
      ArticleSection(
        heading: 'Common Recovery Symptoms',
        bulletPoints: [
          'Lochia (postpartum bleeding)',
          'Perineal soreness',
          'Afterpains',
          'Breast engorgement',
        ],
      ),
      ArticleSection(
        heading: 'When to Call the Doctor',
        content:
            'Always seek medical advice if you experience heavy bleeding, fever, or severe pain. Don\'t ignore your instincts.',
      ),
    ],
  ),
];
