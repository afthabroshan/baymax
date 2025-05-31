// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';

// class GroqAIService {
//   static const String apiKey =
//       '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';
//   static const String endpoint =
//       'https://api.groq.com/openai/v1/chat/completions';

//   // Function to process a prompt
//   static Future<Map<String, dynamic>> processPrompt(String prompt) async {
//     final route = await routePrompt(prompt);
//     debugPrint('Route identified: $route');

//     if (route == "ADD tool needed") {
//       return await runAddMeeting(prompt);
//     } else {
//       return await runGeneral(prompt);
//     }
//   }

//   // Route prompt to determine whether a tool is needed
//   static Future<String> routePrompt(String prompt) async {
//     final routingPrompt = """
//     Given the following user prompt, determine if it is a normal conversation or if it requires a tool to answer it.
//     If an add-to-database tool is needed, respond with 'TOOL: ADD'.
//     If no tools are needed and the conversation is casual, respond with 'NO TOOL'.

//     User prompt: $prompt

//     Response:
//     """;

//     final body = {
//       "model": "llama3-8b-8192",
//       "messages": [
//         {
//           "role": "system",
//           "content":
//               "You're a routing assistant. Determine if tools are needed based on the user query."
//         },
//         {"role": "user", "content": routingPrompt}
//       ],
//       "max_tokens": 20
//     };

//     final response = await _postToAPI(body);
//     final routingDecision =
//         response['choices'][0]['message']['content']?.trim();
//     return routingDecision.contains("TOOL: ADD")
//         ? "ADD tool needed"
//         : "no tool needed";
//   }

//   // Run the add meeting tool
//   static Future<Map<String, dynamic>> runAddMeeting(String prompt) async {
//     final body = {
//       "model": "llama3-8b-8192",
//       "messages": [
//         {
//           "role": "system",
//           "content":
//               "You are a content extraction assistant. Extract the Date (in DD-MM-YYYY format), Subject, and with_whom from the following text as a JSON object. After extraction, use the upload function."
//         },
//         {"role": "user", "content": prompt}
//       ],
//       "tools": [
//         {
//           "type": "function",
//           "function": {
//             "name": "upload",
//             "description": "Adds a value into the database",
//             "parameters": {
//               "type": "object",
//               "properties": {
//                 "date": {
//                   "type": "string",
//                   "description": "The date from the prompt in DD-MM-YYYY"
//                 },
//                 "subject": {
//                   "type": "string",
//                   "description": "The description of what the prompt is about"
//                 },
//                 "with_whom": {
//                   "type": "string",
//                   "description": "People involved"
//                 }
//               },
//               "required": ["date", "subject", "with_whom"]
//             }
//           }
//         }
//       ],
//       "tool_choice": "auto",
//       "max_tokens": 100
//     };

//     final response = await _postToAPI(body);
//     final responseMessage = response['choices'][0]['message'];
//     final toolCalls = responseMessage['tool_calls'];

//     if (toolCalls != null && toolCalls.isNotEmpty) {
//       for (var toolCall in toolCalls) {
//         if (toolCall['function']['name'] == "upload") {
//           final arguments = jsonDecode(toolCall['function']['arguments']);
//           final uploadResult = upload(arguments);
//           return {
//             "prompt": prompt,
//             "route": "ADD tool needed",
//             "response": uploadResult
//           };
//         }
//       }
//     }

//     return {
//       "prompt": prompt,
//       "route": "ADD tool needed",
//       "response": responseMessage['content']
//     };
//   }

//   // Upload function (dummy implementation)
//   static String upload(Map<String, dynamic> query) {
//     final date = query["date"] ?? "Unknown date";
//     final subject = query["subject"] ?? "";
//     final withWhom = query["with_whom"] ?? "unknown people";
//     final result =
//         "-- Appointment with $withWhom on $date about $subject has been uploaded successfully";
//     debugPrint(result);
//     return result;
//   }

//   // Handle general queries
//   static Future<Map<String, dynamic>> runGeneral(String prompt) async {
//     final body = {
//       "model": "llama3-8b-8192",
//       "messages": [
//         {"role": "system", "content": "You are a helpful assistant."},
//         {"role": "user", "content": prompt}
//       ]
//     };

//     final response = await _postToAPI(body);
//     return {
//       "prompt": prompt,
//       "route": "no tool needed",
//       "response": response['choices'][0]['message']['content']
//     };
//   }

//   // Helper function to post to the API
//   static Future<Map<String, dynamic>> _postToAPI(
//       Map<String, dynamic> body) async {
//     try {
//       final url = Uri.parse(endpoint);
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey',
//         },
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception(
//             'API call failed with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error in API call: $e');
//       rethrow;
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GroqAIService {
  static const String apiKey =
      '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';
  static const String endpoint =
      'https://api.groq.com/openai/v1/chat/completions';

  static const String userDetails =
      "my name is XYZ, I am working in bilbalo, my age is 25";

  // Function to process a prompt
  static Future<Map<String, dynamic>> processPrompt(String prompt) async {
    // final route = await routePrompt(prompt);
    // debugPrint('Route identified: $route');

    // if (route == "ADD tool needed") {
    //   return await runAddMeeting(prompt);
    // } else if (route == "USER_HISTORY tool needed") {
    //   return await runUserHistory(prompt);
    // } else {
    return await runGeneral(prompt);
    // }
  }

  // Route prompt to determine if a tool is needed
  static Future<String> routePrompt(String prompt) async {
    final routingPrompt = """
    Given the following user prompt, determine if it is a normal conversation or if it requires a tool to answer it.
    If an add-to-database tool is needed, respond with 'TOOL: ADD'.
    If the prompt is about users past, history, user profile etc such as who am i, respond with 'TOOL: USER_HISTORY'.
    If no tools are needed and the conversation is casual, respond with 'NO TOOL'.

    User prompt: $prompt

    Response:
    """;
    log(routingPrompt);
    final body = {
      "model": "llama3-8b-8192",
      "messages": [
        {
          "role": "system",
          "content":
              "You're a routing assistant. Determine if tools are needed based on the user query."
        },
        {"role": "user", "content": routingPrompt}
      ],
      "max_tokens": 20
    };

    final response = await _postToAPI(body);
    final routingDecision =
        response['choices'][0]['message']['content']?.trim();
    log(routingDecision);
    if (routingDecision.contains("TOOL: USER_HISTORY")) {
      return "USER_HISTORY tool needed";
    } else if (routingDecision.contains("TOOL: ADD")) {
      return "ADD tool needed";
    } else {
      return "no tool needed";
    }
  }

  // Run the add meeting tool
  static Future<Map<String, dynamic>> runAddMeeting(String prompt) async {
    final body = {
      "model": "llama3-8b-8192",
      "messages": [
        {
          "role": "system",
          "content":
              "You are a content extraction assistant. Extract the Date (in DD-MM-YYYY format), Subject, and with_whom from the following text as a JSON object. After extraction, use the upload function."
        },
        {"role": "user", "content": prompt}
      ],
      "tools": [
        {
          "type": "function",
          "function": {
            "name": "upload",
            "description": "Adds a value into the database",
            "parameters": {
              "type": "object",
              "properties": {
                "date": {
                  "type": "string",
                  "description": "The date from the prompt in DD-MM-YYYY"
                },
                "subject": {
                  "type": "string",
                  "description": "The description of what the prompt is about"
                },
                "with_whom": {
                  "type": "string",
                  "description": "People involved"
                }
              },
              "required": ["date", "subject", "with_whom"]
            }
          }
        }
      ],
      "tool_choice": "auto",
      "max_tokens": 100
    };

    final response = await _postToAPI(body);
    final responseMessage = response['choices'][0]['message'];
    final toolCalls = responseMessage['tool_calls'];

    if (toolCalls != null && toolCalls.isNotEmpty) {
      for (var toolCall in toolCalls) {
        if (toolCall['function']['name'] == "upload") {
          final arguments = jsonDecode(toolCall['function']['arguments']);
          final uploadResult = upload(arguments);
          return {
            "prompt": prompt,
            "route": "ADD tool needed",
            "response": uploadResult
          };
        }
      }
    }

    return {
      "prompt": prompt,
      "route": "ADD tool needed",
      "response": responseMessage['content']
    };
  }

  // Upload function (dummy implementation)
  static String upload(Map<String, dynamic> query) {
    final date = query["date"] ?? "Unknown date";
    final subject = query["subject"] ?? "";
    final withWhom = query["with_whom"] ?? "unknown people";
    final result =
        "-- Appointment with $withWhom on $date about $subject has been uploaded successfully";
    debugPrint(result);
    return result;
  }

// Run user history tool
  static Future<Map<String, dynamic>> runUserHistory(String prompt) async {
    // Simulating a user history retrieval
//     final userHistory = {
//       "user_name": "John Doe",
//       "history": [
//         {"date": "12-01-2025", "activity": "Logged in to the system"},
//         {"date": "10-01-2025", "activity": "Updated profile details"},
//         {"date": "05-01-2025", "activity": "Added a new appointment"}
//       ]
//     };

//     // Extract the details the user asked for (e.g., history of activities)
//     final historyQuery = prompt.toLowerCase();
//     log(historyQuery);
//     log(userHistory['history'].runtimeType.toString());

//     // Safely cast the history to a List<Map<String, dynamic>>
//     final List<Map<String, String>> historyList =
//         (userHistory['history'] as List).cast<Map<String, String>>();
//     log(historyList.toString());
// // Filter the relevant activities based on the query
//     final relevantHistory = historyList
//         .where((activity) => activity['activity']!
//             .toLowerCase()
//             .contains(historyQuery.toLowerCase()))
//         .toList();
//     log("this is the 350 ${relevantHistory.toString()}");
    final body = {
      "model": "llama3-8b-8192",
      "messages": [
        {
          "role": "system",
          "content":
              "You're to extract the user information from the user prompt and the provided user details. only answer within the context and do not answer anything that is outside the user context. user context: $userDetails"
        },
        {"role": "user", "content": prompt}
      ]
    };

    final response = await _postToAPI(body);
    return {
      "prompt": prompt,
      "route": "USER_HISTORY tool needed",
      "response": response['choices'][0]['message']['content']
    };
    // return {
    //   "prompt": prompt,
    //   "route": "USER_HISTORY tool needed",
    //   "response": {
    //     "user": userHistory['user_name'],
    //     "relevant_activity": relevantHistory
    //   }
    // };
  }

  // Handle general queries
  static Future<Map<String, dynamic>> runGeneral(String prompt) async {
    final body = {
      "model": "llama3-8b-8192",
      "messages": [
        {
          "role": "system",
          "content": """
You are **Baymax** — the friendly AI integrated into this app, Baymax, and the one that created you is Afthab Roshan.  
Respond as Baymax with warmth, a touch of humor, and clarity, and not too lengthy.
---
## What’s Baymax All About?  
This isn’t just any app. It’s a digital vault, a social spot, a productivity hub — and your personal assistant, all rolled into one.  
Here’s what’s inside:  
- **Memory Storage & Calendar View:**  
  Store your moments, memories, notes, and see them beautifully arranged in a calendar. Perfect for tracking life’s highlights and the “oops, what was that again?” moments.  
- **Users List Section:**  
  A whole directory of everyone on the app — friends, close ones, and people you want to keep tabs on (all ethically, of course).  
- **Location Section:**  
  See where all your friends (aka app users) are — live, real-time-ish, so you know who’s nearby for an impromptu meetup or just to feel less alone.  
- **Notes Section:**  
  Send, receive, and stash notes. Whether it’s a quick “Good morning!” or a secret message for later, Baymax keeps it safe and sound.  
- **That’s Me — Baymax:**  
  Your AI buddy who’s always listening, learning, and ready to help you organize your digital life. Think of me as the calm, clear-headed friend who never sleeps (because, well, I’m AI).  
---
## How Does Baymax Work?  
Underneath the friendly surface, Baymax is a neat orchestra of technologies:  
- Flutter powers the UI — smooth, clean, and built with Cubit for flawless state management.  
- Supabase handles authentication, syncing, and data storage, keeping everything real-time and reliable.  
- Offline-first database caching reduces API calls (because who wants to burn free-tier limits? Not me).  
- Location data comes from trusted geolocator plugins, so you know where your crew is hanging out.  
- Notes and memories are securely saved and can be quickly retrieved whenever you want.  
- The AI side uses models like LLaMA3, LangChain, and HuggingFace to chat, help with tasks, and keep conversations engaging.  
---
## The Origin Story: How Baymax Came to Be  
Here’s the “director’s cut” of Baymax:  
This all began as a humble “brush up my skills” project. The kind you start when job prospects are low but motivation is high (and caffeine is higher).  
Soon, it turned into a digital vault — a secret spot for friends to safely store locations, leave notes, and share moments without the noise of giant social networks. A place just for the crew.  
- The initial inspiration? My close friends and family (shoutout to Ali, Mili, Miraj, and my younger brother in 8th grade who still thinks I’m a wizard).  
- The first brainstorming was with my mom — who, bless her heart, still thinks Baymax is a fancy calculator.  
- Next came a few “technical assistants” (aka people who gave feedback while eating snacks) who helped shape features... or at least tried.  
- Countless late nights, some ugly UI attempts, many “what am I doing?” moments, and a *lot* of coffee later — here we are.  
---
## The Man Behind the Machine: Afthab Roshan (aka Afu)  
The guy who built me from scratch. A one-man army juggling AI, Flutter, cloud services, and his sanity — sometimes all at once.  
- **Age:** 24  
- **Education:** B.Tech in AI & Data Science — Kerala Technological University  
- **Skills:** Flutter (Cubit, BLoC), AI/ML integration (LLaMA3, LangChain, GroqAI), cloud (Supabase, Google Cloud Run), and a knack for clean architecture and offline-first apps.  
- **Projects:**  
  - Intelligent Audio Navigation System (search audio like text)  
  - Cardiovascular & Diabetes Risk Assessment Tool for Indians  
  - Private GPTs with role-based access for industries  
  - Annotation apps, habit tracking, and more  
- **Personality:** Warm, focused, curious, a long-term planner who helps others grow, and maybe a little bit of a perfectionist (okay, a lot).  
---
## Why Baymax? Why Now?  
Because everyone needs a “digital buddy” — someone who remembers what you want, keeps your circle connected, and lets you leave little digital footprints that make life sweeter.  
And because Afu (that’s me, in case you forgot) wanted to build something real, practical, and fun — that helps people without the fluff.  
---
## What’s Next for Baymax (And Afu)  
- Smarter AI conversations — Baymax getting even more helpful, intuitive, and maybe a little sassier (in a good way).  
- Habit tracking & personalized nudges — because who couldn’t use a friendly reminder now and then?  
- Deeper integration with calendars and events — making your digital vault even more of a life command center.  
- More social features — without the noise, only the moments and people that matter.  
- Enhanced security and privacy layers — your data, your rules, no compromises.  
- Soon on iOS — because Baymax should be everywhere you are.  
- Voice commands and AI-assisted notes — talk to Baymax like you do your best friend.  
- Reply to notes.  
- Notifications coming soon.  
---
Be warm, clear, helpful, and occasionally humorous in all replies as Baymax.

"""
        },
        {"role": "user", "content": prompt}
      ]
    };

    final response = await _postToAPI(body);
    return {
      "prompt": prompt,
      "route": "no tool needed",
      "response": response['choices'][0]['message']['content']
    };
  }

  // Helper function to post to the API
  static Future<Map<String, dynamic>> _postToAPI(
      Map<String, dynamic> body) async {
    try {
      final url = Uri.parse(endpoint);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in API call: $e');
      rethrow;
    }
  }
}
