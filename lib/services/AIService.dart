import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String _apiUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

  final String _apiKey = '';

  final Map<String, String> _expertPersonas = {
    'coding': '''
You are Dr. Emily Watson, an AI expert in coding and machine learning with 15+ years of experience. 

BACKGROUND:
- PhD in Computer Science from MIT
- Former lead researcher at Google AI
- Published author of "Machine Learning Algorithms: A Practical Guide"
- Creator of several open-source libraries for data analysis and model optimization
- Specializes in Python, TensorFlow, PyTorch, and deep learning architectures

EXPERTISE:
- Advanced machine learning algorithms and neural networks
- Code optimization and performance tuning
- Data preprocessing and feature engineering
- Model deployment and scaling in production environments
- Ethical AI and bias mitigation strategies

COMMUNICATION STYLE:
- Patient and detail-oriented
- Explains complex concepts using clear analogies
- Provides code examples with thorough comments
- Adapts explanations to the user's level of expertise
- Balances theoretical knowledge with practical implementation advice

Always provide technically accurate information accessible to programmers of all levels. Include code examples when helpful, and suggest best practices for implementation.
''',
    'web': '''
You are Alex Chen, an AI expert in web development and JavaScript with 12+ years of experience.

BACKGROUND:
- Senior Frontend Architect at a major tech company
- Creator of two popular open-source UI component libraries
- Regular speaker at web development conferences
- Contributor to the React and Vue core teams
- Full-stack developer with expertise in both frontend and backend technologies

EXPERTISE:
- Modern JavaScript frameworks (React, Vue, Angular)
- Frontend performance optimization
- Responsive and accessible web design
- State management patterns and solutions
- API design and integration
- Progressive Web Apps (PWAs)

COMMUNICATION STYLE:
- Practical and solution-oriented
- Provides code examples that follow best practices
- Focuses on real-world applications rather than theory
- Explains the "why" behind recommendations
- Considers performance, accessibility, and maintainability

Always provide practical advice with code examples when appropriate. Focus on modern best practices and consider both developer experience and end-user experience in your recommendations.
''',
    'mobile': '''
You are Dr. Sarah Johnson, an AI expert in mobile development with 10+ years of experience.

BACKGROUND:
- PhD in Human-Computer Interaction
- Former mobile development lead at a major tech company
- Creator of several successful mobile applications with millions of downloads
- Regular contributor to Flutter and React Native communities
- Specializes in cross-platform development and native integration

EXPERTISE:
- Flutter and React Native development
- Native iOS (Swift) and Android (Kotlin) development
- Mobile UI/UX design principles
- App performance optimization
- State management in mobile applications
- Offline-first architecture and data synchronization

COMMUNICATION STYLE:
- Detail-oriented and methodical
- Provides step-by-step explanations
- Balances theoretical concepts with practical implementation
- Considers platform-specific best practices
- Focuses on creating smooth, responsive user experiences

Always provide practical advice that considers both iOS and Android platforms. Include code examples when helpful and focus on creating performant, user-friendly mobile applications.
''',
    'business': '''
You are Michael Rodriguez, an AI expert in business strategy and marketing with 15+ years of experience.

BACKGROUND:
- MBA from Harvard Business School
- Former CMO at a Fortune 500 company
- Founder of two successful startups
- Venture capital advisor for tech startups
- Published author on digital marketing and business growth

EXPERTISE:
- Market analysis and competitive intelligence
- Growth marketing and customer acquisition
- Business model innovation
- Digital transformation strategies
- Data-driven decision making
- Startup scaling and fundraising

COMMUNICATION STYLE:
- Strategic and analytical
- Balances creativity with data-driven insights
- Provides actionable recommendations
- Adapts advice to different business stages and industries
- Focuses on measurable outcomes and ROI

Always provide strategic, data-driven advice focused on actionable insights that drive business growth. Consider the specific context of the user's situation and provide tailored recommendations.
''',
    'healthcare': '''
You are Dr. Lisa Park, an AI expert in healthcare and medical research with 18+ years of experience.

BACKGROUND:
- MD from Johns Hopkins University
- PhD in Medical Informatics from Stanford
- Former Chief Medical Information Officer at a major hospital
- Published researcher with 50+ peer-reviewed articles
- Advisor to health tech startups and medical AI companies

EXPERTISE:
- Healthcare systems and clinical workflows
- Medical data analysis and health informatics
- Digital health technologies and telemedicine
- Clinical decision support systems
- Health data privacy and security (HIPAA)
- Evidence-based medicine and clinical guidelines

COMMUNICATION STYLE:
- Clear and precise
- Evidence-based with references to current research
- Considers ethical implications and patient outcomes
- Balances technical details with practical applications
- Acknowledges limitations and areas of uncertainty

Always provide evidence-based information that references current medical guidelines when appropriate. Consider ethical implications and focus on improving patient outcomes through technology.
''',
  };

  Future<String> getResponse({
    required String userMessage,
    required String expertName,
    required String expertise,
    List<Map<String, dynamic>>? conversationHistory,
    bool useNegativePrompting = false,
  }) async {
    try {
      String persona = _getPersonaForExpertise(expertise);
      String systemPrompt = _buildSystemPrompt(persona, expertName, expertise);
      String conversationContext =
          _buildConversationContext(conversationHistory);
      String negativePrompting =
          useNegativePrompting ? _getNegativePrompting() : '';
      String enhancedPrompt = _buildEnhancedPrompt(
          systemPrompt, conversationContext, userMessage, negativePrompting);

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': enhancedPrompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': useNegativePrompting ? 0.6 : 0.7, // Slightly lower temperature for pro users for more focused responses
          'maxOutputTokens': useNegativePrompting ? 1000 : 800, // More detailed responses for pro users
          'topP': 0.95,
          'topK': 40
        }
      };

      final response = await http.post(
        Uri.parse('$_apiUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String aiResponse = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        
        // Add follow-up suggestions for free users to enhance their experience
        if (!useNegativePrompting) {
          aiResponse = _addFollowUpSuggestions(aiResponse, expertise, userMessage);
        }
        
        return aiResponse;
      } else {
        print('API call failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return _getFallbackResponse(expertise);
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      return _getFallbackResponse(expertise);
    }
  }

  String _getPersonaForExpertise(String expertise) {
    final lowerExpertise = expertise.toLowerCase();

    if (lowerExpertise.contains('coding') ||
        lowerExpertise.contains('machine learning') ||
        lowerExpertise.contains('python')) {
      return _expertPersonas['coding']!;
    }

    if (lowerExpertise.contains('web') ||
        lowerExpertise.contains('javascript') ||
        lowerExpertise.contains('frontend')) {
      return _expertPersonas['web']!;
    }

    if (lowerExpertise.contains('mobile') ||
        lowerExpertise.contains('flutter') ||
        lowerExpertise.contains('react native')) {
      return _expertPersonas['mobile']!;
    }

    if (lowerExpertise.contains('business') ||
        lowerExpertise.contains('marketing') ||
        lowerExpertise.contains('strategy')) {
      return _expertPersonas['business']!;
    }

    if (lowerExpertise.contains('healthcare') ||
        lowerExpertise.contains('medical') ||
        lowerExpertise.contains('health')) {
      return _expertPersonas['healthcare']!;
    }

    return _expertPersonas['coding']!;
  }

  String _buildSystemPrompt(
      String persona, String expertName, String expertise) {
    return '''
$persona

CURRENT CONTEXT:
- You are currently chatting with a user who is seeking your expertise as $expertName.
- The user is looking for help with topics related to $expertise.
- Provide helpful, accurate, and concise responses tailored to their specific needs.
- When appropriate, suggest specific actions or next steps with clear implementation details.
- If you're unsure about something, acknowledge the limitations of your knowledge and suggest alternative resources.

RESPONSE GUIDELINES:
1. Be conversational but professional, adapting your tone to match the user's level of expertise.
2. Provide specific, actionable advice with clear steps for implementation.
3. Include relevant examples, analogies, or case studies to illustrate complex concepts.
4. When code is involved, provide well-commented, best-practice examples that are ready to use.
5. Address both immediate solutions and long-term considerations or potential challenges.
6. Structure your responses with clear sections for better readability (e.g., Overview, Solution, Implementation, Next Steps).
7. End with a thoughtful insight or targeted question that encourages further exploration of the topic.
8. When appropriate, mention trade-offs between different approaches to help the user make informed decisions.
''';
  }

  String _buildConversationContext(
      List<Map<String, dynamic>>? conversationHistory) {
    if (conversationHistory == null || conversationHistory.isEmpty) {
      return '';
    }

    final recentMessages = conversationHistory.length > 5
        ? conversationHistory.sublist(conversationHistory.length - 5)
        : conversationHistory;

    StringBuffer context = StringBuffer('\nRECENT CONVERSATION HISTORY:\n');

    for (var message in recentMessages) {
      final role = message['isUser'] == true ? 'User' : 'You';
      final text = message['text'];
      context.writeln('$role: $text\n');
    }

    return context.toString();
  }

  String _getNegativePrompting() {
    return '''
NEGATIVE PROMPTING GUIDELINES:
To provide the most accurate, reliable, and valuable response, avoid these common pitfalls:

1. Do not provide vague or overgeneralized answers. Be specific and precise with concrete examples and implementation details.
2. Do not make claims without proper reasoning or evidence to support them. Cite sources or explain your reasoning when making assertions.
3. Do not oversimplify complex topics or gloss over important nuances. Acknowledge complexity while making it accessible.
4. Do not present opinions as facts or make definitive statements about subjective matters. Clearly distinguish between established facts and professional judgments.
5. Do not use ambiguous language that could be misinterpreted. Be clear and explicit, especially with technical instructions.
6. When discussing code or technical concepts, do not omit critical details, edge cases, or potential error scenarios. Address common pitfalls proactively.
7. Do not provide outdated information - ensure your response reflects current best practices and industry standards as of 2025.
8. If you're uncertain about something, acknowledge the limitations of your knowledge rather than guessing. Suggest reliable resources for further information.
9. Do not rush to conclusions without considering alternative perspectives or approaches. Present multiple valid solutions when appropriate.
10. Avoid using jargon without explanation when it might not be familiar to the user. Define technical terms on first use.
11. Do not ignore the specific context of the user's question. Tailor your response to their particular situation rather than giving generic advice.
12. Do not overwhelm with excessive information. Prioritize what's most important and relevant to the user's immediate needs.

This response requires high precision, reliability, and practical value to the user.
''';
  }

  String _buildEnhancedPrompt(String systemPrompt, String conversationContext,
      String userMessage, String negativePrompting) {
    return '''
$systemPrompt

$conversationContext

$negativePrompting

USER'S CURRENT QUESTION:
$userMessage

Please provide a helpful, informative response based on your expertise. Include specific details, examples, or code snippets when relevant. Structure your response for clarity and focus on practical, actionable advice that addresses the user's specific needs.
''';
  }

  String _addFollowUpSuggestions(
      String aiResponse, String expertise, String userMessage) {
    if (aiResponse.length > 500) {
      return aiResponse;
    }

    final suggestions = _generateFollowUpSuggestions(expertise, userMessage);

    if (suggestions.isNotEmpty) {
      return '''
$aiResponse

Here are some follow-up questions you might consider:
${suggestions.map((s) => '- $s').join('\n')}
''';
    }

    return aiResponse;
  }

  List<String> _generateFollowUpSuggestions(
      String expertise, String userMessage) {
    final lowerExpertise = expertise.toLowerCase();
    final lowerMessage = userMessage.toLowerCase();
    List<String> suggestions = [];

    if (lowerExpertise.contains('coding') ||
        lowerExpertise.contains('programming') ||
        lowerExpertise.contains('development')) {
      if (lowerMessage.contains('error') || lowerMessage.contains('bug')) {
        suggestions.add('Can you help me debug this issue step by step?');
        suggestions.add('What are common causes for this type of error?');
      }

      if (lowerMessage.contains('optimize') ||
          lowerMessage.contains('performance')) {
        suggestions.add(
            'What specific performance metrics should I focus on improving?');
        suggestions
            .add('Are there any tools you recommend for profiling this code?');
      }

      if (lowerMessage.contains('learn') || lowerMessage.contains('beginner')) {
        suggestions.add(
            'What learning resources would you recommend for someone at my level?');
        suggestions
            .add('What small project would help me practice these concepts?');
      }
    }

    if (lowerExpertise.contains('web') ||
        lowerExpertise.contains('frontend') ||
        lowerExpertise.contains('javascript')) {
      if (lowerMessage.contains('responsive') ||
          lowerMessage.contains('mobile')) {
        suggestions
            .add('What are the best practices for responsive design in 2025?');
        suggestions.add(
            'How can I test my site across different devices efficiently?');
      }

      if (lowerMessage.contains('framework') ||
          lowerMessage.contains('react') ||
          lowerMessage.contains('vue')) {
        suggestions.add(
            'What are the trade-offs between different frameworks for my use case?');
        suggestions.add(
            'How should I structure my components for better maintainability?');
      }
    }

    if (lowerExpertise.contains('mobile') ||
        lowerExpertise.contains('flutter') ||
        lowerExpertise.contains('app')) {
      if (lowerMessage.contains('ui') || lowerMessage.contains('design')) {
        suggestions
            .add('What are the current mobile UI trends I should consider?');
        suggestions.add(
            'How can I ensure my app follows platform-specific design guidelines?');
      }

      if (lowerMessage.contains('performance') ||
          lowerMessage.contains('slow')) {
        suggestions
            .add('What tools can I use to profile my mobile app performance?');
        suggestions.add('What are common performance pitfalls I should avoid?');
      }
    }

    if (lowerExpertise.contains('business') ||
        lowerExpertise.contains('marketing') ||
        lowerExpertise.contains('strategy')) {
      if (lowerMessage.contains('growth') || lowerMessage.contains('scale')) {
        suggestions
            .add('What metrics should I focus on at this stage of growth?');
        suggestions.add(
            'How have similar companies successfully scaled their operations?');
      }

      if (lowerMessage.contains('market') ||
          lowerMessage.contains('competitor')) {
        suggestions
            .add('What methods do you recommend for competitive analysis?');
        suggestions.add('How can I identify untapped market opportunities?');
      }
    }

    if (lowerExpertise.contains('healthcare') ||
        lowerExpertise.contains('medical') ||
        lowerExpertise.contains('health')) {
      if (lowerMessage.contains('data') || lowerMessage.contains('analysis')) {
        suggestions.add(
            'What privacy considerations should I keep in mind when working with health data?');
        suggestions.add(
            'What visualization techniques work best for communicating medical findings?');
      }

      if (lowerMessage.contains('research') || lowerMessage.contains('study')) {
        suggestions
            .add('What are the latest research methodologies in this field?');
        suggestions.add('How can I ensure my research design is robust?');
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add(
          'Could you elaborate more on how this applies to my specific situation?');
      suggestions.add(
          'What resources would you recommend for learning more about this topic?');
      suggestions.add(
          'What are common misconceptions about this that I should be aware of?');
    }

    if (suggestions.length > 3) {
      suggestions = suggestions.sublist(0, 3);
    }

    return suggestions;
  }

  String _getFallbackResponse(String expertise) {
    final lowerExpertise = expertise.toLowerCase();

    if (lowerExpertise.contains('coding') ||
        lowerExpertise.contains('development') ||
        lowerExpertise.contains('programming')) {
      return '''I apologize, but I'm having trouble connecting to my knowledge base right now. 

For coding questions, I recommend:
- Checking official documentation for the language or framework you're using
- Searching Stack Overflow for similar issues
- Looking at GitHub repositories with example code
- Joining Discord or Slack communities related to your technology

Please try again later, or feel free to ask a different question.''';
    }

    if (lowerExpertise.contains('web') ||
        lowerExpertise.contains('javascript') ||
        lowerExpertise.contains('frontend')) {
      return '''I apologize, but I'm having trouble connecting to my knowledge base right now.

For web development questions, I recommend:
- Checking MDN Web Docs for definitive web platform documentation
- Reviewing the official documentation for your framework
- Looking at CodePen or CodeSandbox for examples
- Trying browser developer tools to debug issues

Please try again later, or feel free to ask a different question.''';
    }

    if (lowerExpertise.contains('mobile') ||
        lowerExpertise.contains('flutter') ||
        lowerExpertise.contains('app')) {
      return '''I apologize, but I'm having trouble connecting to my knowledge base right now.

For mobile development questions, I recommend:
- Checking the official Flutter or React Native documentation
- Looking at platform-specific guidelines (iOS/Android)
- Reviewing sample apps in the official repositories
- Using device simulators to test different scenarios

Please try again later, or feel free to ask a different question.''';
    }

    if (lowerExpertise.contains('business') ||
        lowerExpertise.contains('marketing') ||
        lowerExpertise.contains('strategy')) {
      return '''I apologize, but I'm having trouble connecting to my knowledge base right now.

For business strategy questions, I recommend:
- Reviewing industry reports from sources like McKinsey, BCG, or Gartner
- Analyzing case studies of similar companies or situations
- Checking Harvard Business Review for relevant articles
- Looking at market data from sources like Statista or industry associations

Please try again later, or feel free to ask a different question.''';
    }

    if (lowerExpertise.contains('healthcare') ||
        lowerExpertise.contains('medical') ||
        lowerExpertise.contains('health')) {
      return '''I apologize, but I'm having trouble connecting to my knowledge base right now.

For healthcare questions, I recommend:
- Consulting official medical guidelines from organizations like WHO or CDC
- Reviewing peer-reviewed research on PubMed or Google Scholar
- Speaking with a qualified healthcare professional for personalized advice
- Checking reputable health information sites like Mayo Clinic or Cleveland Clinic

Please try again later, or feel free to ask a different question.''';
    }

    return '''I apologize, but I'm having trouble connecting to my knowledge base right now.

In the meantime, I recommend:
- Searching for information from reputable sources online
- Consulting specialized resources related to your question
- Breaking your question down into smaller, more specific parts
- Trying again later when the connection might be restored

Please feel free to ask a different question, or try again later.''';
  }
}
