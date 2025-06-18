# ChatGPT Service Documentation

## Overview
The ChatGPT Service is a core component of the Women Safety Support App that provides intelligent, empathetic, and context-aware responses to user messages. It handles message processing, emergency detection, and resource recommendations.

## Technical Architecture

### Class Structure
```dart
class ChatGPTService {
  static final Map<String, List<String>> _resourceResponses;
  static final Map<String, List<String>> _defaultResponses;
  
  static String _getDefaultResponse(String message);
  static Future<String> sendMessage(String message);
}
```

### Response Categories

#### 1. Resource Responses
- `emergency_contacts`: Emergency service numbers and guidance
- `support_services`: Professional support service contacts
- `ngo_helplines`: NGO contact information
- `crisis_helplines`: Mental health and crisis support numbers
- `quick_help`: Immediate assistance options

#### 2. Default Responses
- `greeting`: Welcome and initial interaction messages
- `emergency`: Responses for crisis situations
- `support`: General support and guidance
- `safety`: Safety-related advice and planning
- `empowerment`: Encouraging and empowering messages
- `default`: Generic supportive responses
- `affirmative`: Positive acknowledgment responses

## Message Processing

### Input Processing
1. Message is trimmed and converted to lowercase
2. Keywords are extracted and matched against categories
3. Context is analyzed for emergency situations
4. Appropriate response category is selected

### Keyword Categories
```dart
Map<String, Map<String, dynamic>> keywordCategories = {
  'greeting': {
    'keywords': Set<String>,
    'requireExactMatch': bool
  },
  'emergency': {
    'keywords': Set<String>,
    'requireExactMatch': bool,
    'appendResource': String
  },
  // ... other categories
};
```

### Response Generation Process

1. **Message Reception**
   ```dart
   static Future<String> sendMessage(String message)
   ```
   - Validates input
   - Initiates response generation

2. **Keyword Matching**
   - Checks for exact matches (when required)
   - Performs partial matching
   - Identifies multiple relevant categories

3. **Response Selection**
   - Chooses appropriate response category
   - Randomly selects from available responses
   - Appends relevant resources when needed

4. **Special Cases**
   - Emergency number queries
   - Very short messages
   - Empty messages
   - Unknown contexts

## Emergency Detection

### Priority Keywords
- Immediate danger: 'urgent', 'emergency', 'danger'
- Violence: 'abuse', 'attack', 'beaten'
- Mental health: 'suicide', 'kill', 'death'
- Distress: 'scared', 'help me', 'unsafe'

### Response Protocol
1. Identifies emergency keywords
2. Prioritizes safety-related responses
3. Includes relevant emergency contact information
4. Provides immediate action steps

## Resource Management

### Resource Categories
1. **Emergency Services**
   - Police
   - Ambulance
   - Women's Helpline

2. **Support Organizations**
   - Women's Commission
   - Domestic Violence Help
   - Legal Aid

3. **Mental Health Support**
   - Crisis Helplines
   - Counseling Services
   - Mental Health Professionals

### Resource Delivery
- Contextual resource inclusion
- Format with emojis for readability
- Prioritized based on urgency
- Follow-up questions for clarification

## Response Formatting

### Message Structure
```
[Main Response]
[Empty Line]
[Resource Information (if applicable)]
[Follow-up Question]
```

### Emoji Usage
- 🚨 Emergency services
- 👮‍♀️ Police
- 🚑 Ambulance
- 👩‍💼 Women's helpline
- 📞 Contact numbers
- 💜 Support messages
- 🆘 Emergency button

## Best Practices

### Response Guidelines
1. Always maintain empathetic tone
2. Include actionable next steps
3. Provide relevant resources
4. Ask follow-up questions
5. Keep responses concise and clear

### Safety Considerations
1. Prioritize user safety
2. Include emergency options
3. Provide multiple support paths
4. Maintain privacy and security
5. Enable quick access to help

## Error Handling

### Input Validation
- Empty message handling
- Special character processing
- Message length checks
- Language detection

### Fallback Responses
- Default supportive messages
- Generic resource information
- Encouragement to provide more details
- Safety-first approach

## Performance Considerations

### Optimization
1. Static response maps
2. Efficient keyword matching
3. Quick resource access
4. Minimal processing overhead

### Response Time
- Immediate response generation
- Quick emergency detection
- Fast resource retrieval
- Efficient message processing

## Future Enhancements

### Planned Features
1. Machine learning integration
2. Multi-language support
3. Voice message processing
4. Sentiment analysis
5. Personalized responses

### Integration Points
1. Location services
2. Emergency contact system
3. Resource database
4. User preferences
5. Safety features

## Testing

### Test Categories
1. Message processing
2. Emergency detection
3. Resource delivery
4. Response formatting
5. Error handling

### Test Cases
```dart
void main() {
  test('Emergency keyword detection', () {
    final response = ChatGPTService.sendMessage('help emergency');
    expect(response, contains('emergency'));
  });
  
  // Add more test cases
}
``` 