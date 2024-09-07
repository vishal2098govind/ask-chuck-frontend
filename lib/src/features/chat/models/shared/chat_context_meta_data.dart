import 'package:ask_chuck/src/core/parser.dart';

class ChatContextMetaData {
  final String? contentType;
  final num? page;
  final String? source;
  final String? title;

  const ChatContextMetaData({
    required this.contentType,
    required this.page,
    required this.source,
    required this.title,
  });

  factory ChatContextMetaData.fromMap(Object? map) {
    switch (map) {
      case Map():
        return ChatContextMetaData(
          contentType: parseValueType<String?>(
            map["content-type"],
            defaultValue: null,
          ),
          page: parseValueType<num?>(
            map["page"],
            defaultValue: null,
          ),
          source: parseValueType<String?>(
            map["source"],
            defaultValue: null,
          ),
          title: parseValueType<String?>(
            map["title"],
            defaultValue: null,
          ),
        );
    }

    return const ChatContextMetaData(
      contentType: null,
      page: null,
      source: null,
      title: null,
    );
  }
}

// {
//     "input": "Why are thy discussed?",
//     "chat_history": [
//         {
//             "content": "What are design factors?",
//             "additional_kwargs": {},
//             "response_metadata": {},
//             "type": "human",
//             "name": null,
//             "id": null,
//             "example": false
//         },
//         {
//             "content": "Design factors are documents that develop insights about functions. They are titled next to the function they refer to and contain information about both insight and ideas. They are qualitative, with an emphasis on insight, and can be incorporated into the Function Structure. \n",
//             "additional_kwargs": {},
//             "response_metadata": {},
//             "type": "ai",
//             "name": null,
//             "id": null,
//             "example": false,
//             "tool_calls": [],
//             "invalid_tool_calls": [],
//             "usage_metadata": null
//         }
//     ],
//     "context": [
//         {
//             "id": null,
//             "metadata": {
//                 "content-type": "application/pdf",
//                 "page": 4.0,
//                 "source": "https://firebasestorage.googleapis.com/v0/b/askchuck.appspot.com/o/Charles%20Owen%2FContext-for-creativity-Owen_deseng91.pdf?alt=media&token=649a3f47-6417-4be5-9fa8-08a00551f91e",
//                 "title": "Charles Owen/Context-for -creativity-Owen_deseng91.pdf"
//             },
//             "page_content": "with individual Functions.\nDesign Factors Several features characterize the Design Factor document.\nFirst, a Design Factor is a document. It has source and reference information, as\nwell as discussion material and illustrations. Second, it contains information about\nboth insight and ideas. In one place, the source for ideas and the ideas themselves\nare recorded. Third, it is qualitative. Quantitative information can be incorporated,\nbut the emphasis is on insight, described in the way most appropriate—generally in\nprose, with mathematical and/or graphic illustrations where useful.\nIn the Design Factor there resides a model for a corporate or institutional memory\nassociated with the \"why’s\" rather than the \"what’s\" of project histories. Ideas and\nthe insights that produced them are the diamonds among the enormous amounts of\n\"data dust\" accumulated by corporations and institutions. Billions of dollars must be\nlost every year by corporations that recreate the wheel over and over again",
//             "type": "Document"
//         },
//         {
//             "id": null,
//             "metadata": {
//                 "content-type": "application/pdf",
//                 "page": 4.0,
//                 "source": "https://firebasestorage.googleapis.com/v0/b/askchuck.appspot.com/o/Charles%20Owen%2FContext-for-creativity-Owen_deseng91.pdf?alt=media&token=649a3f47-6417-4be5-9fa8-08a00551f91e",
//                 "title": "Charles Owen/Context-for -creativity-Owen_deseng91.pdf"
//             },
//             "page_content": "Function Structure), there is a section for what are called Design Factors\njuxtaposed to the list of Functions. Design Factors are documents developing\ninsights about Functions. They are titled next to the Function (or Functions) to\nwhich they refer.\nAt this stage of preparation—what would be analysis in the classic model—the\ncreative process begins in the Structured Planning process. The generation of\nDesign Factors forces the interplay of insight and idea at the micro-level associated\nwith individual Functions.\nDesign Factors Several features characterize the Design Factor document.\nFirst, a Design Factor is a document. It has source and reference information, as\nwell as discussion material and illustrations. Second, it contains information about\nboth insight and ideas. In one place, the source for ideas and the ideas themselves\nare recorded. Third, it is qualitative. Quantitative information can be incorporated,",
//             "type": "Document"
//         },
//         {
//             "id": null,
//             "metadata": {
//                 "content-type": "application/pdf",
//                 "page": 4.0,
//                 "source": "https://firebasestorage.googleapis.com/v0/b/askchuck.appspot.com/o/Charles%20Owen%2FContext-for-creativity-Owen_deseng91.pdf?alt=media&token=649a3f47-6417-4be5-9fa8-08a00551f91e",
//                 "title": "Charles Owen/Context-for -creativity-Owen_deseng91.pdf"
//             },
//             "page_content": "5design process as one that proceeds linearly or iteratively through the phases of\nanalysis, synthesis and evaluation. Insight and idea go hand in hand. When\ninsights are obtained, it is crucial to capture the ideas that may follow naturally.\nAs Activities are described and functions specified in the Action Analysis process,\ninsights are also sought in the immediacy of the moment. On the Action Analysis\nform (Fig. 2) used to analyze Activities (and develop the information for the\nFunction Structure), there is a section for what are called Design Factors\njuxtaposed to the list of Functions. Design Factors are documents developing\ninsights about Functions. They are titled next to the Function (or Functions) to\nwhich they refer.\nAt this stage of preparation—what would be analysis in the classic model—the\ncreative process begins in the Structured Planning process. The generation of\nDesign Factors forces the interplay of insight and idea at the micro-level associated",
//             "type": "Document"
//         }
//     ],
//     "answer": "Design factors are discussed because they represent a way to capture and preserve valuable insights and ideas that emerge during the planning process. They help to avoid the costly repetition of work by providing a record of past solutions and the reasoning behind them. \n"
// }