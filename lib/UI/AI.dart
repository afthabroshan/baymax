// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AIPage extends StatefulWidget {
//   const AIPage({super.key});

//   @override
//   _AIPageState createState() => _AIPageState();
// }

// class _AIPageState extends State<AIPage> {
//   TextEditingController _controller = TextEditingController();
//   List<Map<String, String>> _messages = []; // List to hold the sent and received messages
//   bool _loading = false;

//   // Function to send the message and get response from the server
//   Future<void> sendMessage() async {
//     if (_controller.text.isEmpty) return;

//     setState(() {
//       _loading = true;
//     });

//     // Replace with your server URL
//     String url = 'http://127.0.0.1:11434/api/generate'; // Example API endpoint
//     String prompt = _controller.text;

//     // API request
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'model': 'llama3.2',
//         'prompt': prompt,
//       }),
//     );

//     if (response.statusCode == 200) {
//       String cleanedResponse = response.body.trim();
//       log(cleanedResponse);
//       // Parse response
//       Map<String, dynamic> data = json.decode(cleanedResponse);

//       String aiResponse = data['response'] ?? "No response";

//       // Add both sent message and AI response to the list
//       setState(() {
//         _messages.clear(); // Clear previous messages
//         _messages.add({'type': 'user', 'message': prompt});
//         _messages.add({'type': 'ai', 'message': aiResponse});
//         _loading = false;
//       });
//     } else {
//       setState(() {
//         _loading = false;
//       });
//       // Handle error if any
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to get response")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AI Chatbot'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Display messages
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   return MessageWidget(
//                     type: _messages[index]['type']!,
//                     message: _messages[index]['message']!,
//                   );
//                 },
//               ),
//             ),
//             // Message input and send button
//             if (!_loading)
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: InputDecoration(
//                         hintText: "Type your message...",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: () {
//                       sendMessage(); // Send message when pressed
//                     },
//                   ),
//                 ],
//               ),
//             if (_loading)
//               CircularProgressIndicator(), // Show loading indicator while waiting for AI response
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Custom widget to show the message with different styles based on the sender
// class MessageWidget extends StatelessWidget {
//   final String type; // 'user' or 'ai'
//   final String message;

//   const MessageWidget({required this.type, required this.message});

//   @override
//   Widget build(BuildContext context) {
//     bool isUser = type == 'user';
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Align(
//         alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
//           decoration: BoxDecoration(
//             color: isUser ? Colors.blueAccent : Colors.grey[300],
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: Text(
//             message,
//             style: TextStyle(color: isUser ? Colors.white : Colors.black),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class AIPage extends StatefulWidget {
  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<Map<String, String>> _messages = [];
  // List _messages = [];
  String accumulatedResponse = '';
  String AImessages = '';
  // Function to send message to AI model and get streaming response
  Future<void> sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({'type': 'user', 'message': _controller.text});
      _loading = true;
      accumulatedResponse = '';
    });

    String url =
        'http://192.168.1.5:11434/api/generate'; // Update to correct API endpoint http://127.0.0.1:11434/api/generate
    String prompt = _controller.text;
    _controller.clear();
    try {
      final client = http.Client();
      final request = http.Request('POST', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({
          'model': 'perski', // Ensure this is the correct model version
          'prompt': prompt,
        });

      // Send the request and receive the stream
      final streamedResponse = await client.send(request);

      // Listen to the stream and handle the incoming data
      streamedResponse.stream.listen(
        (List<int> chunk) {
          // Convert the chunk into a string
          String responseChunk = utf8.decode(chunk);

          // Accumulate the chunks
          accumulatedResponse += responseChunk;

          // Try parsing multiple JSON objects from the accumulated response
          while (accumulatedResponse.isNotEmpty) {
            try {
              // Look for the first valid JSON object
              int startIndex = accumulatedResponse.indexOf('{');
              int endIndex = accumulatedResponse.indexOf('}');

              if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
                // Extract the complete JSON object
                String jsonStr =
                    accumulatedResponse.substring(startIndex, endIndex + 1);
                accumulatedResponse =
                    accumulatedResponse.substring(endIndex + 1);
                log("this is 212 $jsonStr");
                // Parse the JSON object
                Map<String, dynamic> responseData = json.decode(jsonStr);
                String aiResponse = responseData['response'] ?? "";
                log("this is the airesonse from 215 $aiResponse");
                AImessages += aiResponse;
                log(accumulatedResponse);
                // if (aiResponse.isNotEmpty) {
                //   setState(() {
                //     _messages.add({'type': 'ai', 'message': aiResponse});
                //   });
                // }
                if (responseData['done'] == true) {
                  setState(() {
                    _messages.add({'type': 'ai', 'message': AImessages});
                    _loading = false;
                  });
                  AImessages = '';
                }
                // Check if the response is done
                // if (responseData['done'] == true) {
                //   log("this is the responseData from 224 $responseData");
                //   log("this is the airesponse from 225 $aiResponse");
                //   setState(() {
                //     _messages.add({'type': 'ai', 'message': accumulatedResponse});
                //     _loading = false;
                //     // _messages.add({'type': 'ai', 'message': aiResponse});
                //   });
                //   accumulatedResponse = '';
                //   //  _messages.add({'type': 'ai', 'message': aiResponse});
                //   break;
                // }
              } else {
                // Not a valid JSON object, break out of the loop and wait for more data
                break;
              }
            } catch (e) {
              print("Error parsing chunk: $e");
              break; // Stop processing if an error occurs
            }
          }
        },
        onDone: () {
          // All chunks have been received
          setState(() {
            _loading = false;
          });
        },
        onError: (e) {
          print("Error in stream: $e");
          setState(() {
            _loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e")),
          );
          log(e);
        },
      );
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Page')),
      body: Column(
        children: [
          Container(
            height: 300.h,
            width: 250.w,
            child: Column(
              children: [
                Lottie.asset('assets/voice.json', fit: BoxFit.fill),
                Lottie.asset('assets/electrician.json', fit: BoxFit.fill),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message['message'] ?? ''),
                  subtitle: Text(message['type'] == 'user' ? 'User' : 'AI'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Ask something...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
          if (_loading)
            CircularProgressIndicator(), // Show loading indicator while waiting
        ],
      ),
    );
  }
}
