import 'dart:math';

import 'package:stuttherapy/exercise_library/exercise_ressources.dart';


List<String> words = [
  "Colonel", "Quinoa", "Scissors", "Anemone", "Squirrel",
  "Successful", "Alias", "Camaraderie", "Demagogue", "Espresso",
  "Mischievous", "Fridge", "Gorgeous", "Thoroughly", "Daughter",
  "Variety", "Throughout", "Appliance", "Refrigerator", "Shrimp",
  "Adjective", "Vocabulary", "Psychologist", "Genuine", "Trade",
  "Aberration", "Abnegation", "Heterogenous", "Impecunious", "Inimical",
  "Fallacious", "Extraneous", "Insidious", "Multifarious", "Derivative",
  "Neophyte", "Obdurate", "Complement", "Obfuscate", "Officious",
  "Paradigm", "Pejorative", "Philanthropic", "Plenitude", "Potentate",
  "Proclivity", "Requisition", "Sobriety", "Spurious", "Subjugate",
  "Ubiquitous", "Approbation", "Abstruse", "Advocate", "Bombastic",
  "Cupidity", "Calumny", "Murder", "Literature", "Assailant",
  "Cognizant", "Catastrophic", "Contusion", "Convivial", "Denigrate",
  "Ambivalent", "Development", "Decision", "Capitulate", "Unfortunate",
  "Duplicity", "Empirical", "Exacerbate", "Ambulance", "Disaffected",
  "Contentious", "Inveterate", "Paradigm", "Language", "Dogmatic",
  "Rhetorical", "Grandfather", "Ceaseless", "Satisfying", "Downtown",
  "Echanting", "Malicious", "Adverse", "Club", "Authority",
  "Didactic", "Permissible", "Communicate", "Disrepute", "Important",
  "Amorphous", "Terrific", "Spotless", "Boundary", "Disparate",
  "Asterisk", "Defibrillator", "Comfortable", "February", "Rural",
];

List<String> sentences = [
  "I’m studying Russian literature.",
  "We rarely go to the beach.",
  "It’s a difficult situation.",
  "I added a little bit of pepper to the recipe.",
  "One disadvantage of living in a big city is the pollution.",
  "There are approximately 400 million native English speakers in the world.",
  "There’s fresh fruit salad in the refrigerator.",
  "You should always tell the truth.",
  "Do you think that music can influence society?",
  "Unfortunately, it looks like it’s going to rain all weekend.",
  "I’d like to improve my vocabulary.",
  "I’m having a particularly bad day today.",
  "The order of these words is not important.",
  "Would and wood sound the same when you say them out loud.",
  "The air is so cold you can see your breath.",
  "You can download classic literature for free online.",
  "English is a difficult language to learn.",
  "If you practise, your English will improve little by little.",
  "One exclamation mark is enough to get your point across.",
  "It is unfortunate that the weather has delayed our trip.",
  "When you hear an ambulance you must pull over to the side of the road.",
  "The bride looked gorgeous on her wedding day.",
  "My daughter asked if she could have a friend over for a playdate.",
  "It is important to use sentence variety.",
  "Celebrities influence how young people act and dress.",
  "The new company policy will take effect next month.",
  "Victoria is located on Vancouver Island in British Columbia.",
  "Another appliance that is considered a necessity is the refrigerator.",
  "Left handed people require a special type of scissors.",
  "Expand your vocabulary by reading blogs when you are online.",
  "A psychologist told me that I need to learn how to relax.",
  "But the information is basically the same.",
  "My mom drove me to school fifteen minutes late on Tuesday.",
  "The girl wore her hair in two braids, tied with two blue bows.",
  "The mouse was so hungry he ran across the kitchen floor without even looking for humans.",
  "The tape got stuck on my lips so I couldn't talk anymore.",
  "The door slammed down on my hand and I screamed like a little baby.",
  "My shoes are blue with yellow stripes and green stars on the front.",
  "The mailbox was bent and broken and looked like someone had knocked it over on purpose.",
  "I was so thirsty I couldn't wait to get a drink of water.",
  "I found a gold coin on the playground after school today.",
  "The chocolate chip cookies smelled so good that I ate one without asking.",
  "My bandaid wasn't sticky any more so it fell off on the way to school.",
  "He had a sore throat so I gave him my bottle of water and told him to keep it.",
  "The church was white and brown and looked very old.",
  "I was so scared to go to a monster movie but my dad said he would sit with me so we went last night.",
  "Your mom is so nice she gave me a ride home today.",
  "I fell in the mud when I was walking home from school today.",
  "This dinner is so delicious I can't stop eating.",
  "The school principal was so mean that all the children were scared of him.",
  "I accidentally left my money in my pants pocket and it got ruined in the washer.",
  "I piled my books in my arms and then they fell all over the floor.",
  "My sister likes to eat cheese on her peanut butter sandwich and pickles on her ice cream.",
  "The gum was stuck under the desk and I couldn't get it off.",
  "I don't know where my list of friends went to invite them to my birthday party.",
  "My buddy is going to pick me up after school and give me a ride to work.",
  "My home is bright pink and has yellow flowers growing all around it.",
  "I got my finger stuck in the door when I slammed it.",
  "The chickens were running around and pecking worms out of the ground.",
  "My dad told me that I was his favorite person in the whole wide world.",
  "We need to rent a room for our party.",
  "He told us a very exciting adventure story.",
  "She did not cheat on the test, for it was not the right thing to do.",
  "If I don’t like something, I’ll stay away from it.",
  "I want more detailed information.",
];

List<String> texts = [
  "When you picture mountain climbers scaling Mount Everest, what probably comes to mind are teams of climbers with Sherpa guides leading them to the summit, equipped with oxygen masks, supplies and tents. And in most cases you'd be right, as 97 per cent of climbers use oxygen to ascend to Everest's summit at 8,850 metres above sea level. The thin air at high altitudes makes most people breathless at 3,500 metres, and the vast majority of climbers use oxygen past 7,000 metres."
  "Sam squinted against the sun at the distant dust trail raked up by the car on its way up to the Big House. The horses kicked and flicked their tails at flies, not caring about their owner's first visit in ten months. Sam waited. Mr Carter didn't come out here unless he had to, which was just fine by Sam. The more he kept out of his boss's way, the longer he'd have a job.",
  "The two men looked towards the northern end of the property. It stretched as far as the eye could see. Even the fences were barely visible from where they stood. However bored and rebellious a teenage boy might get, it wasn't possible to escape on foot. Sam looked at the biggest of the horses, kicking at the ground with its heavy hooves. Could the boy ride? he wondered.",
  "Their efforts failed. So, instead, they searched for a variety of banana that the fungus didn’t affect. They found the Cavendish, as it was called, in the greenhouse of a British duke. It wasn’t as well suited to shipping as the Gros Michel, but its bananas tasted good enough to keep consumers happy. Most importantly, TR-1 didn’t seem to affect it.",
  "Growing practices in South East Asia haven’t helped matters. Growers can’t always afford the expensive lab-based methods to clone plants from shoots without spreading the disease. Also, they often aren’t strict enough about cleaning farm equipment and quarantining infected fields. As a result, the fungus has spread to Australia, the Middle East and Mozambique – and Latin America, heavily dependent on its monoculture Cavendish crops, could easily be next.",
  "Much of today's business is conducted across international borders, and while the majority of the global business community might share the use of English as a common language, the nuances and expectations of business communication might differ greatly from culture to culture. A lack of understanding of the cultural norms and practices of our business acquaintances can result in unfair judgements, misunderstandings and breakdowns in communication.",
  "This stark difference in opinion over something that could be conceived as minor and thus easily overlooked goes to show that we often attach meaning to even the most mundane practices. When things that we are used to are done differently, it could spark the strongest reactions in us.",
  "An American or British person might be looking their client in the eye to show that they are paying full attention to what is being said, but if that client is from Japan or Korea, they might find the direct eye contact awkward or even disrespectful. In parts of South America and Africa, prolonged eye contact could also be seen as challenging authority. In the Middle East, eye contact across genders is considered inappropriate, although eye contact within a gender could signify honesty and truthfulness.",
  "Having an increased awareness of the possible differences in expectations and behaviour can help us avoid cases of miscommunication, but it is vital that we also remember that cultural stereotypes can be detrimental to building good business relationships. Although national cultures could play a part in shaping the way we behave and think, we are also largely influenced by the region we come from, the communities we associate with, our age and gender, our corporate culture and our individual experiences of the world.",
  "Pinker asks us to stop paying so much attention to negative headlines and news that declares the end of the world. Instead, he shows us some carefully selected data. In 75 surprising graphs, we see that safety, peace, knowledge and health are getting better all over the world. When the evidence does not support his argument, however, he dismisses it. Economic inequality, he claims, is not really a problem, because it is not actually that important for human well-being. One cannot help wondering how many people actually living in poverty would agree.",
  "For more than two hundred years the pessimists have been winning the public debate. They tell us that things are getting worse. But in fact, life is getting better. Income, food availability and lifespan are rising; disease, violence and child mortality are falling. These trends are happening all around the world. Africa is slowly coming out of poverty, just as Asia did before. The internet, mobile phones and worldwide trade are making the lives of millions of people much better.",
  "The majority of people believe that developing countries are in a terrible situation: suffering from incredible poverty, governed by dictators and with little hope for any meaningful change. But, surprisingly, this is far from the truth. The reality is that a great transformation is occurring. Over the past 20 years, more than 700 million people have increased their income and come out of poverty. Additionally, six million fewer children die every year from disease, millions more girls are in school and millions of people have access to clean water.",
  "Your manager stops you and says she needs to have a word about your performance in the recent project. You worry about it all weekend, wondering what you might have done wrong. When you step into her office on Monday morning she begins by praising you for the good work you've done on the project, and you wonder if this is the obligatory praise that starts off the typical 'feedback sandwich'. You know how the feedback sandwich goes: say something nice, say what you really want to say, say something nice again.",
  "Psychologist and 'growth mindset' proponent Carol Dweck spoke of the plasticity of the brain and our ability to develop skills and talents that we might not have been good at to start with. Many of us tend to focus our praise on the end result and seemingly innate talents, e.g. 'You really have an eye for details' or 'You have a real talent for organising events'.",
  "It might take time to counter the effects of an environment where there is a cynical view of positive feedback, but in the long run, by embracing positive feedback, you can not only enhance working performance but also enrich the quality of life in the workplace. ",
  "Since almost the beginning of cinema, we have had scary films. Of all the genres that exist, horror is perhaps one of the most conventional. Many horror films rely on specific plot devices, also called tropes, to make their audience frightened. When a trope is used too much, it can become a cliché. But when used well, it can really make us jump out of our skin. Here are some of the most used, and perhaps abused, clichés in horror films.",
  "In older horror films, when protagonists were in desperation, it was difficult or impossible for them to call for help or call the police. Mobile phones have made that situation a bit less believable now. What's the solution to maintain suspense? No phone coverage! If you're a hero in a horror film, it's almost certain that at a key moment, just when you absolutely need to call for help, you will not have any coverage at all. Or your phone battery will die just as you are making the call. Or both.",
  "We know that human language is far more complex than that of even our nearest and most intelligent relatives like chimpanzees. We can express complex thoughts, convey subtle emotions and communicate about abstract concepts such as past and future. And we do this following a set of structural rules, known as grammar. Do only humans use an innate system of rules to govern the order of words? Perhaps not, as some research may suggest dolphins share this capability because they are able to recognise when these rules are broken.",
  "If we want to know where our capability for complex language came from, we need to look at how our brains are different from other animals. This relates to more than just brain size; it is important what other things our brains can do and when and why they evolved that way. And for this there are very few physical clues; artefacts left by our ancestors don't tell us what speech they were capable of making. One thing we can see in the remains of early humans, however, is the development of the mouth, throat and tongue.",
  "More questions lie in looking at the influence of genetics on brain and language development. Are there genes that mutated and gave us language ability? Researchers have found a gene mutation that occurred between 200,000 and 100,000 years ago, which seems to have a connection with speaking and how our brains control our mouths and face. Monkeys have a similar gene, but it did not undergo this mutation. It's too early to say how much influence genes have on language, but one day the answers might be found in our DNA.",
  "A new study published in the journal Science shows definitive evidence of organic matter on the surface of Mars. The data was collected by NASA's nuclear-powered rover Curiosity. It confirms earlier findings that the Red Planet once contained carbon-based compounds. These compounds – also called organic molecules – are essential ingredients for life as scientists understand it.",
  "Scientists are quick to state that the presence of these organic molecules is not sufficient evidence for ancient life on Mars, as the molecules could have been formed by non-living processes. But it's still one of the most astonishing discoveries, which could lead to future revelations. Especially when one considers the other startling find that Curiosity uncovered around five years ago.",
  "The possibility of life on Mars has fascinated humans for generations. It has been the subject of endless science-fiction novels and films. Are we alone in the universe or have there been other life forms within our Solar System? If the current missions to the Red Planet continue, it looks as if we may discover the answer very soon. ",
  "Judy really enjoys working with you and the team and finds the project very interesting, but I think she's feeling a bit lost and struggling to see the big picture. It seems that she's been given a fair amount of autonomy to carry out the tasks that you've given her, and of course this level of delegation is not uncommon in your branch. But I believe in her Tokyo office, she is used to a bit more managerial direction and guidance and so is finding this international project quite daunting.",
  "Looking ahead, I was wondering if we could make it easier for Judy by offering her more direction when setting her tasks, at least until she learns the ropes and gets used to working unsupervised. I think she'd also appreciate you giving her a clearer idea on how her role in the team fits into the overview of things.",
  "Judy is an extremely conscientious worker and is eager to contribute positively to the team. Personally, I think she is someone with high potential and will be an asset to our international projects if properly mentored. I'm keen to know your thoughts on the matter and am open to any suggestions on how we could better support Judy so that she has a more smooth-sailing experience on the team.",
  "But supermarkets and grocers are starting to sit up and take notice. In response to growing consumer backlash against the huge amounts of plastic waste generated by plastic packaging, some of the largest UK supermarkets have signed up to a pact promising to transform packaging and cut plastic wastage.",
  "Some smaller companies are now taking matters into their own hands and offering consumers a greener, more environmentally friendly option. Shops like Berlin's Original Unverpakt and London's Bulk Market are plastic-free shops that have opened in recent years, encouraging customers to use their own containers or compostable bags. ",
  "There is no doubt that we still have a long way to go in reducing food waste and plastic waste. But perhaps the major supermarkets might take inspiration from these smaller grocers and gradually move towards a more sustainable future for us all.",
  "In the last two centuries, improvements in technology and health meant fewer children died young, fuelling rapid population growth. These large families produced even more children who survived into adulthood and had their own children. But with the wider availability of contraception in the 1960s, the global average number of babies per woman has declined from six babies per woman to as low as two.",
  "As for news stories that make us think the world is an increasingly violent place, there is cause for some optimism too. Between the end of World War II and 1990, there were 30 wars that killed more than 100,000 people. Today there are still civil wars, but countries are mostly co-existing more peacefully than in the past. However, terrorism has shot up in the last few years and, since World War II, wars have killed many more civilians than soldiers.",
  "Of course, none of this means the world is perfect, and whether you personally are affected by war and poverty is often down to the lottery of where you're born. Also, we still face huge problems of our own making, particularly environmental ones like global warming, and wealth and natural resources need to be distributed more fairly. ",
  "So then I was posted to LA, which felt like a whole other country compared with the East Coast. I could definitely get used to that kind of outdoor, beach lifestyle, but I didn't spend as much time getting to know California as I could have because I was flying back to see Michael every other weekend. He came to see me when he could, but his job means he's often working at weekends, so he couldn't make the flight very often.",
  "Despite their friendliness, Gabriela didn't feel respected as a leader. Her new staff would question her proposals openly in meetings, and when she gave them instructions on how to carry out a task, they would often go about it in their own way without checking with her. ",
  "What Gabriela was experiencing was a cultural clash in expectations. She was used to a more hierarchical framework where the team leader and manager took control and gave specific instructions on how things were to be done. This more directive management style worked well for her and her team in Brazil but did not transfer well to her new team in Sweden, who were more used to a flatter hierarchy where decision making was more democratic.",
  "Dutch social psychologist Geert Hofstede uses the concept of 'power distance' to describe how power is distributed and how hierarchy is perceived in different cultures. In her previous work environment, Gabriela was used to a high power distance culture where power and authority are respected and everyone has their rightful place.",
  "When Gabriela became aware of the cultural differences between her and her team, she took the initiative to have an open conversation with them about their feelings about her leadership. Pleased to be asked for their thoughts, Gabriela's team openly expressed that they were not used to being told what to do. They enjoyed having more room for initiative and creative freedom.",
  "According to Campbell, the hero at first refuses the call to adventure, but a mentor appears who helps them and they decide to 'cross the threshold' and travel into the 'special world' where the adventure happens. The next stage consists of passing tests, fighting enemies and meeting friends as the hero prepares to face their biggest challenge.",
  "The trend has now reached influencers on social media who usually share posts of clothing and make-up that they recommend for people to buy. Some YouTube stars now encourage their viewers not to buy anything at all for periods as long as a year. Two friends in Canada spent a year working towards buying only food. For the first three months they learned how to live without buying electrical goods, clothes or things for the house.",
  "The changes they made meant two fewer cars on the roads, a reduction in plastic and paper packaging and a positive impact on the environment from all the energy saved. If everyone followed a similar plan, the results would be impressive. But even if you can't manage a full year without going shopping, you can participate in the anti-consumerist movement by refusing to buy things you don't need.",
  "If we look around us at the things we have purchased at some point in our lives, we would no doubt notice that not everything we own is being put to good use: the thick woollen coat which we thought looked trendy despite the fact that we live in a tropical country, the smartphone that got put away when we bought ourselves the newest model, the car that only gets used at the weekends, or even the guest room in our house that somehow got turned into a storeroom.",
  "Businesses have also caught on to the profitability of the sharing economy and are seeking to gain from making use of those underutilised resources. A business model that has rapidly risen in popularity sees companies providing an online platform that puts customers in contact with those who can provide a particular product or service.",
  "Historically, more bridges were made of wood and were much more susceptible to fire. This was particularly true of old-fashioned train bridges, where the spark created by the steel wheels and steel tracks could sometimes cause a bridge to catch fire and burn to the ground.",
  "Earthquakes damage all structures, including bridges. Luckily, this kind of collapse is relatively infrequent, especially with modern bridges. Engineers have learned to design bridges in earthquake zones on areas that are much more resistant to movement.",
  "Some bridge collapses are mysteries, and engineers only realise why after they conduct a complete investigation. In some cases, this could happen because inferior-quality material was used in the construction, or because of a defect in a key piece of the bridge.",
  "I used to do a typical five-day week, but after I came out of my maternity leave, I decided that I wanted to spend more time with my children before they start school. After negotiating with my boss, we decided to cut my working week down to a three-day work week. This of course meant a significant cut in my pay too, as I'm paid on a pro-rata basis.",
];

class ResourceProvider {
  static CollectionExerciseResource getResources(ExerciseResourceEnum resType) {
    switch (resType) {
      case ExerciseResourceEnum.WORDS:
        words.shuffle();
        return CollectionExerciseResource(
          resources: words.map((String w) => ExerciseResource(resource: w, resourceType: ExerciseResourceEnum.WORDS))
        );
      case ExerciseResourceEnum.SENTENCES:
        sentences.shuffle();
        return CollectionExerciseResource(
          resources: sentences.map((String s) => ExerciseResource(resource: s, resourceType: ExerciseResourceEnum.SENTENCES)), 
        );
      case ExerciseResourceEnum.TEXT:
      String text = texts.isEmpty ? null : texts.elementAt(Random().nextInt(texts.length));
        return CollectionExerciseResource(
          resources: [ExerciseResource(resource: text, resourceType: ExerciseResourceEnum.TEXT)]
        );
      default:
        return null;
    }
  }
}