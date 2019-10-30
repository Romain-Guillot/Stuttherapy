import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stuttherapy/env.dart';
import 'package:stuttherapy/strings.dart';
import 'package:stuttherapy/ui/dimen.dart';


List<ManualItem> stuttererItems = [
  ManualItem(
    title: "What can I do with Stuttherapy ?",
    content: """ 
Stuttherapy is an application that helps you **overcome your stuttering** with exercises. Below you can find out how to use the different features of the application:

- Practice on **exercises**;
- Check your **progress**;
- Manage and consult your **saved words**;
- **Synchronize your progress** in the cloud;


*However, keep in mind that Stuttherapy does not replace a doctor or therapist, it should be used as a complementary aid.*
    """,
  ),//- **Share** your progress with your **therapist**.
  ManualItem(
    title: "Exercises",
    content: """
There are currently 3 exercises proposed on the application:
- **Metronome:** Speak with a regular speech rate imposed by a metronome;
- **Reading:** Speak freely with words, sentences or slightly longer texts;
- **Mirroring:** Speak by recording your face in order to analyze your stuttering behaviour.

## Customization
Each of these exercises can be **customized** according to your needs. For example, you can choose which resources you want to work on: words, sentences or texts. Before each exercise you can choose the parameters that suit you.

## Training
The exercises display a series of resources (words, sentences or texts) that you must pronounce, depending on the settings you have chosen, to move from one resource to another you must:
- *Either* **go directly** to the next resource without checking if you have pronounced the current resource correctly...
- *... or either* **select words** you couldn't pronounce correctly to saved them.

When you start an exercise, you can stop it at any time, your current progress will be recorded. 
""",
  ),
  ManualItem(
    title: "Progress",
    content: """
For each exercise you can visualize your progress in 2 ways:

- A **list of all the exercises** you have done;
- Line chart to view your weekly, monthly or annual progress.

## List of exercises
All the exercises you have done are listed in this list. For each exercise you can access:
- The date of the training;
- Audio or video recording of the exercise (if enabled);
- The list of words that you have not been able to pronounce correctly.

## Line chart
You can choose the time window on which to view your progress: weekly, monthly or yearly.  
This graph shows the percentage of successful pronunciation of the words used in the exercises, i.e. the ratio of the total number of words correctly pronounced to the total number of words pronounced.  
If you have done a lot of exercises, you can zoom in on the graph to analyze your progress more accurately.
""",
  ),
  ManualItem(
    title: "Saved words",
    content: """
During your training on the different exercises you can choose to manually select the words that you have not been able to pronounce correctly.

You can access the list of all these words to practice on them, simply view or delete them. 

*Tip:* This list can be found in the main menu of the application (button at the top left of the main page)
""",
  ),
  ManualItem(
    title: "Cloud synchronisation",
    content: """
You can synchronize your progress exercises in the cloud to make sure you don't lose them and can restore them at any time on all your Android devices. 

In order to synchronize your progress, you must create an account (with a name, email address and password). Once the account is created you can synchronize the exercises of your progress on the cloud.

Once connected, simply open the exercises you want to synchronize in the progress list, and click on the synchronization button.

*Tip:* The registration and login buttons are located in the main menu of the application (button at the top left of the main page). You can remove an exercise from your synchronized progress in the cloud at any time.
""",
  ),//Synchronization is also useful to share your progress with your therapist (see the guide below).
  if(enableTherapistFeatures) 
  ManualItem(
    title: "Share your progress with your therapist",
    content: """
You can share your synchronized progress on the cloud with your therapist. To learn more about the synchronization, please refer to the previous guide.

From the application's home page you can access your ***Feed***. Your Feed contains all your synchronized exercises which there are also accessible by your therapist.

To add a therapist, go to *My Feed* and click on the *Add* button to add a therapist. You need to know your therapist's ID to add it, ask him, he will find it on his application. Once added, your therapist will have access to all your synchronized exercises and will be able to leave feedback on each of them.
"""
  )
];

List<ManualItem> therapistItems = [
  ManualItem(
    title: "What can I do with Stuttherapy ?",
    content: """
As a therapist, you can **monitor the progress of your patients**. You will have access to the exercises that your patients have decided to share with you.

For more information on how the exercises work, please refer to the *stutterer* guides.

*Note:* Unlike stutterers, to access the features as a therapist **you must create an account**.
""",
  ),
  ManualItem(
    title: "Add and remove patients",
    content: """
You cannot directly add a patient. It is the patient who must add you in order for you to have access to his or her progress.

Once logged in, you have access to your ID, you must **give this ID to your patients** so that they can add you. Once a patient adds you, you will automatically have access to their Feed. Refer to the guides below for more information about Feed.

Unlike adding a patient, you can delete a patient at any time, click on the patient to be deleted and click on the button to delete the patient.
""",
  ),
  ManualItem(
    title: "View patients progress (patient Feed)",
    content: """
If a patient has added you as a therapist you have access to his progression that he has decided to synchronize with you: his Feed.

A patient's Feed is made up of the exercises they have performed and synchronized in the cloud.

The patient's progress is a list of exercises, for more information on the patient's progress, please refer to the *Progress* guide of the *Stutterer*.
""",
  ),
  ManualItem(
    title: "Add feeback",
    content: """
For each patient exercise in their Feed, you can add feedback. Simply click on the *Edit feedback* button, the patient will then be able to read this feedback.  
""",
  ),
];


class Manual extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    if(enableTherapistFeatures) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(text: Strings.ACCOUNT_STUTTERER,),
                Tab(text: Strings.ACCOUNT_THERAPIST),
              ],
            ),
            title: Text(Strings.MANUAL_TITLE),
          ),
          body: TabBarView(
            children: [
              ManualList(items: stuttererItems),
              ManualList(items: therapistItems),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(Strings.MANUAL_TITLE),
          ),
          body: 
              ManualList(items: stuttererItems),
            
      );
    }
    
  }


}

class ManualList extends StatefulWidget {

  final List<ManualItem> items;

  ManualList({Key key, @required this.items}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ManualList> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(24.0),
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  widget.items[index].isExpanded = !isExpanded;
                });
              },
              children: widget.items.map<ExpansionPanel>((ManualItem item) {
                return ExpansionPanel(
                  isExpanded: item.isExpanded,
                  headerBuilder: (context, expanded) =>ListTile(
                    title: Text(item.title),
                    onTap: () => setState(() => item.isExpanded = !item.isExpanded),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(Dimen.PADDING),
                    child: MarkdownBody(data: item.content,),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
  }
}

class ManualItem {
  bool isExpanded = false;
  String title;
  String content;

  ManualItem({@required this.title, @required this.content});
}