# UI Components Documentation

## Overview
The Women Safety Support App uses Flutter for its user interface, providing a clean, intuitive, and responsive design that prioritizes quick access to emergency features while maintaining a supportive and calming environment.

## Core Components

### 1. Emergency Button
```dart
class EmergencyButton extends StatelessWidget {
  // Large, prominent button for immediate assistance
  // Always visible and accessible
  // Triggers emergency protocol on activation
}
```

**Features:**
- Prominent red color
- Always visible floating action button
- Haptic feedback on press
- Confirmation dialog for accidental touches
- Quick access to emergency services

### 2. Chat Interface
```dart
class ChatInterface extends StatefulWidget {
  // Main chat interaction area
  // Displays messages and responses
  // Handles user input
}
```

**Components:**
- Message input field
- Send button
- Message bubbles
- Loading indicators
- Resource cards
- Quick action buttons

### 3. Resource Directory
```dart
class ResourceDirectory extends StatelessWidget {
  // Organized list of help resources
  // Categorized for easy access
  // One-touch contact options
}
```

**Sections:**
- Emergency Contacts
- Support Services
- NGO Directory
- Legal Resources
- Mental Health Support

## Layout Structure

### 1. Main Screen
```dart
Scaffold(
  appBar: AppBar(title: "Women Safety Support"),
  body: ChatInterface(),
  floatingActionButton: EmergencyButton(),
  bottomNavigationBar: NavigationBar(),
)
```

### 2. Chat Layout
```dart
Column(
  children: [
    MessagesList(),
    InputField(),
  ],
)
```

### 3. Resource Layout
```dart
ListView(
  children: [
    ResourceCategory(),
    ResourceItems(),
  ],
)
```

## Design System

### Colors
```dart
class AppColors {
  static const primary = Color(0xFF1A73E8);    // Google Blue
  static const emergency = Color(0xFFD32F2F);   // Red
  static const support = Color(0xFF1976D2);     // Blue
  static const success = Color(0xFF388E3C);     // Green
  static const background = Color(0xFFFAFAFA);  // Light Grey
}
```

### Typography
```dart
class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const body = TextStyle(
    fontSize: 16,
    height: 1.5,
  );
  
  static const caption = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
}
```

### Spacing
```dart
class AppSpacing {
  static const small = 8.0;
  static const medium = 16.0;
  static const large = 24.0;
  static const xlarge = 32.0;
}
```

## Message Components

### 1. User Message Bubble
```dart
class UserMessageBubble extends StatelessWidget {
  final String message;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(message),
    );
  }
}
```

### 2. Assistant Message Bubble
```dart
class AssistantMessageBubble extends StatelessWidget {
  final String message;
  final List<Resource>? resources;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MessageText(message),
        if (resources != null) ResourceCards(resources),
      ],
    );
  }
}
```

### 3. Resource Card
```dart
class ResourceCard extends StatelessWidget {
  final String title;
  final String contact;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.phone),
        title: Text(title),
        subtitle: Text(contact),
        onTap: onTap,
      ),
    );
  }
}
```

## Interactive Elements

### 1. Quick Action Buttons
```dart
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
```

### 2. Emergency Dialog
```dart
class EmergencyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Emergency Assistance"),
      content: Column(
        children: [
          EmergencyOptions(),
          ConfirmationButtons(),
        ],
      ),
    );
  }
}
```

## Animations

### 1. Loading Indicator
```dart
class TypeingIndicator extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedDot(),
        AnimatedDot(),
        AnimatedDot(),
      ],
    );
  }
}
```

### 2. Emergency Button Animation
```dart
class PulsingEmergencyButton extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      child: EmergencyButton(),
    );
  }
}
```

## Accessibility Features

### 1. Screen Reader Support
```dart
Semantics(
  label: "Emergency Button",
  hint: "Double tap to activate emergency services",
  child: EmergencyButton(),
)
```

### 2. High Contrast Mode
```dart
class HighContrastTheme {
  static final ThemeData theme = ThemeData(
    brightness: Brightness.high,
    contrastColor: Colors.white,
    // Additional high contrast settings
  );
}
```

## Responsive Design

### 1. Screen Size Adaptation
```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return MobileLayout();
        }
        return TabletLayout();
      },
    );
  }
}
```

### 2. Orientation Handling
```dart
class OrientationAwareLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? PortraitLayout()
            : LandscapeLayout();
      },
    );
  }
}
```

## Testing Guidelines

### 1. Widget Tests
```dart
testWidgets('Emergency button shows confirmation dialog', (tester) async {
  await tester.pumpWidget(EmergencyButton());
  await tester.tap(find.byType(EmergencyButton));
  await tester.pump();
  expect(find.byType(AlertDialog), findsOneWidget);
});
```

### 2. Integration Tests
```dart
testWidgets('Complete emergency flow', (tester) async {
  await tester.pumpWidget(MyApp());
  // Test complete emergency activation flow
});
```

## Best Practices

1. **Accessibility**
   - Maintain minimum touch target size (48x48dp)
   - Provide clear contrast ratios
   - Include meaningful semantic labels

2. **Performance**
   - Use const constructors where possible
   - Implement widget keys appropriately
   - Minimize rebuilds

3. **User Experience**
   - Provide immediate feedback
   - Maintain consistent styling
   - Keep emergency features accessible

4. **Safety**
   - Confirm destructive actions
   - Provide clear escape routes
   - Maintain privacy controls 