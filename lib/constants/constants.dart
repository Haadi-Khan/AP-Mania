import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// main
const appTitle = 'AP Assassin';

// color scheme
const kPrimaryColor = Colors.white;
const kBlackColor = Colors.black;
const kGreyColor = Color.fromARGB(255, 240, 240, 240);
const kDarkGreyColor = Color.fromARGB(255, 119, 119, 119);
const kRedColor = Colors.red;
const kErrorColor = Colors.orange;
const kBlueGreenColor = Color.fromARGB(255, 47, 169, 118);
const kMidRedGreyColor = Color.fromARGB(255, 236, 187, 187);

const statusBarColor = SystemUiOverlayStyle(
  statusBarColor: kPrimaryColor,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
const statusBarColorScroll = SystemUiOverlayStyle(
  statusBarColor: kPrimaryColor,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
const myBoldStyle = TextStyle(
    color: kBlackColor, fontWeight: FontWeight.bold, fontSize: 30, height: 1.5);

const homeBlurbStyle = TextStyle(
    color: kBlackColor,
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.2);

// general text
const textStart = 'Get Started';
const textLogin = 'Sign In';
const textSignUp = 'Sign Up';
const textProceed = 'Proceed';
const textCancel = 'Cancel';
const textLoading = 'Loading';

// login text
const textLoginTitle = 'Welcome back!';
const textLoginSubtitle = 'The hunt continues ...';
const textNoAcc = "Don't have an account? ";

// register text
// const textRegisterTitle = 'Create your account!';
// const textRegisterSubtitle = 'And let the games begin';
const textHaveAcc = "Already have an account? ";

const textHintEmail = 'Enter email';
const textHintPass = 'Set password';
const textHintConfirm = 'Confirm password';

// auth error text

const textErrorNoMatch = '  Password must match';
const textErrorWeakPassword = '  Weak password';
const textErrorUserExists = '  Email taken';
const textErrorInvalidEmail = '  Invalid email address';
const textErrorWrongPassword = '  Wrong Password';
const textErrorWrongEmail = '  No user with this email';
const textErrorMissingFields = '  At least one field is empty';

// info text

const textInfoTitle = 'Almost there';
const textInfoSubtitle = 'Enter some personal info';
const textInfoPhoto = 'Submit a clear photo of your face';
const textChoosePhoto = '  Select';
const textTakePhoto = '  Capture';

const textHintFullName = 'Enter full name';
const textHintPhoneNumber = 'Enter phone number';
const textHintNumberAPs = 'Enter # of APs taken';

// game choice text

const textAdmin = '  Coordinator';
const textPlayer = '  Participant';
const textEnterGame = 'Enter Game';
const textSearch = 'Search Game';
const textJoinGame = 'Search Game';
const textCreateGame = 'Start New Game';
const textNewGameName = 'Choose New Name';

const textErrorNoType = '  No account type chosen';
const textErrorNoGame = '  No game chosen';

// verify text

const textRegisterSuccess =
    'You have successfully registered for Hills East AP Assassin';
const textVerification1 = 'Your account will now be manually verified';
const textVerification2 = 'This process should not take more than 24 hours';
const textVerification3 =
    'Contact your coordinator with any questions or issues';

// logout text

const textLogout = 'Log Out';
const textLogoutCheck = 'Are you sure you want to log out?';

// people text

const textShowAlive = 'Remaining Players';
const textShowAll = 'All Players';
const textShowAdmin = 'Coordinators';

const textSortAZ = 'A - Z';
const textSortZA = 'Z - A';
const textSortKills = 'Most Kills';

// rules text

const textRulesTitle1 = 'I. Eligibility, Registration, Payment';
const textRulesContent1 =
    '\nAll participants must have completed or be currently enrolled in at least one Advanced Placement (AP) course and must be members of the HHH High School East Class of 2022. If for some reason you enter and are found to have never taken an AP course, you will be immediately removed from the game, and you will not receive a refund.\n\nThe cost of AP Assassination is \$20, payable in cash or on Venmo to @dsalkinder with a message that says “AP [insert your full name]”. All payments and registrations should be completed and given to the coordinator by FRIDAY, MAY 27 by 2PM. All payments are final and can NOT be refunded. If necessary, text the coordinator to schedule a time and place to submit your money. There will be absolutely no signups after the May 27 deadline. All participants must pay for themselves; you cannot pay for your friends.\n';

const textRulesTitle2 = 'II. General Rules';
const textRulesContent2 =
    '\nAll participants must have completed or be currently enrolled in at least one Advanced Placement (AP) course and must be members of the HHH High School East Class of 2022. If for some reason you enter and are found to have never taken an AP course, you will be immediately removed from the game, and you will not receive a refund.\n\nThe cost of AP Assassination is \$20, payable in cash or on Venmo to @dsalkinder with a message that says “AP [insert your full name]”. All payments and registrations should be completed and given to the coordinator by FRIDAY, MAY 27 by 2PM. All payments are final and can NOT be refunded. If necessary, text the coordinator to schedule a time and place to submit your money. There will be absolutely no signups after the May 27 deadline. All participants must pay for themselves; you cannot pay for your friends.\n';

const textRulesTitle3 = 'III. Assassination; Equipment Restrictions';
const textRulesContent3 =
    '\nAn assassination is defined as hitting a target with the projectile dart of a Nerf (non-expanding recreational foam) gun or similar foam projectile/dart gun (“Nerf” hereafter refers to any Nerf brand or similar brand dart gun). All projectiles must be propelled directly by some sort of handheld weapon, and NOT directly thrown, kicked, swung, etc. by your arms or legs (i.e. you may not use a Nerf football or sword). Only Nerf and similar brand guns and darts may be used. Blowguns, crossbows, and other handheld weapons are allowed as long as they fire regulation/unaltered Nerf darts.\n\nModified dart guns are allowed, but they must be approved by the coordinator in person. Please make arrangements to have your modified Nerf gun approved.\n\nNerf balls and rubber rings used in Vortex or Rival blasters or other blasters are not allowed. Only regulation nerf DARTS are allowed.\n\n​You MAY use your target’s gun, provided you did not acquire it by physical violence. \n\nDO NOT PAINT YOUR NERF GUN BLACK. In the past, police have drawn guns on participants whose Nerf guns resembled real weapons.\n\nDo not wrap nerf darts in tape. \n\nHigh pressure devices (i.e. CO2 cartridges) are strictly prohibited\n';

const textRulesTitle4 = 'IV. Safe Zones; Shields; Retaliation';
const textRulesContent4 =
    '\nAP Assassination related activity MUST NOT occur on Half Hollow Hills High School East property. No assassinations shall take place on the grounds of any Half Hollow Hills Schools facility, including, but not limited to, buildings, parking lots, and athletic facilities.\n\nNerf guns are strictly prohibited on Half Hollow Hills School District property. Any nerf gun found on district property will result in an automatic disqualification.\n\nWhile a target is participating in a school sponsored activity that is off campus, he or she is safe (i.e. participating in a Varsity sports game or a school club organized tournament). If a target is simply ATTENDING a school sponsored event away from High School East, however, he or she is vulnerable. Pasta dinners and dinners at restaurants for sports teams or school clubs are NOT considered school sponsored events.\n\nTargets are safe while at their club sports. This includes all official practice times and games, but NOT unofficial workouts or captains’ practices. The target is safe while participating in the club sport, no matter where they are. This includes games, meets, matches, and regattas. No assassinations can take place while the target is actively participating in any organized sport game, irrespective of whether or not it is school run.\n\nThe buildings and grounds of all Police Departments and Fire Departments are safe zones. Any AP Assassination activity that takes place in any of these locations will result in immediate disqualification from the competition and criminal charges by the Chief of Police. \n\nAll hospitals and hospital parking lots are safe zones. Doctor’s office parking lots are NOT safe zones. \n\nAll Airports are safe zones. This includes inside terminal buildings, on the tarmac, and in the airport parking lot. \n\nA target is safe while INSIDE his or her OWN house (including the garage). The porch, driveway, lawn, and surrounding property are NOT safe. Targets may only be assassinated in their own houses if they or an immediate family member (mom, dad, sibling, or any other family member living in the house) personally invites their assassin into the house no more than 12 hours prior to the assassination. Note that it is always legal to shoot INTO a target’s house, garage, and backyard (i.e. from outside a doorway or through an open window) as long as you do not ENTER uninvited. Please take care to respect the property and the landscape of your target’s house if you are planning a stakeout. Furthermore, beware of houses with guard dogs. Trespassers can be prosecuted at the property owner’s discretion. \n\nIt is LEGAL to shoot a target while he or she is sleeping. Note, however, that merely CLAIMING you assassinated someone while they were asleep will not suffice, since this cannot be verified. TAKE A VIDEO if you plan to make an assassination while the target is sleeping so the assassination can be verified easily, or wake the target up before shooting. \n\nThe interiors of all places of worship are safe zones, regardless of whether religious services are in session. \n\nWhen participants are working (during their shifts, while signed in, or while on duty), they are safe (both inside and outside their places of work). If the target is ON BREAK and is OUTSIDE the building of his/her workplace, he/she is NOT safe (but if the target is on break and INSIDE the building, he/she IS safe). If the target’s job does not take place within an actual building, such as pizza delivery or EMS, the target is safe while on the job. However, targets are not safe while performing under the table jobs such as personal tutoring. Job interviews are also not safe. Note also that if the ASSASSIN is working and his/her target enters the ASSASSIN’s place of work, the target is NOT safe. If you work with a professional tutoring or babysitting business, you are safe while on the job. \n\nIt is illegal to forcibly remove someone from a safe zone. Assaulting a target or assassin is illegal, and use of force may be grounds for the disqualification of an assassination or ejection from the game. Assassins and their accomplices may NOT use physical force to restrain a target. \n\nBodyguards CAN block a shot for a target. Accomplices, however, CANNOT assassinate an assassin’s target; the assigned assassin must commit the assassination. \n\nInanimate shields are NOT allowed. If you or anything you are holding or wearing is struck by a Nerf dart, you have been assassinated. If a bullet is heading towards you or is in flight, you may not throw an object, such as a book or sweatshirt, to use as a shield. \n\nRicochets do not count. Real bullets don’t bounce, after all. \n\nIf an assassin shoots at his or her target and misses, a target can fight back by shooting at the assassin with a Nerf gun that is approved by the earlier stated rules. If the retaliatory shot hits the assassin (same rules as for shooting a target), then the assassin is frozen* for one hour (i.e. no assassination attempt may be made on his/her target for one hour). If an assassin is frozen, the TIME of the freeze should be recorded and announced aloud/agreed upon so that the end of the one hour time period will be clearly defined. Once a Target becomes aware of who his Assassin is, the Target is enabled to fire at and freeze the Assassin at any time when the Assassin is approaching with intent to assassinate. A Target, however, may NOT attempt to freeze his Assassin by randomly shooting at everybody; doing so will not result in a freeze. An Assassin must have prior knowledge of who his/her Assassin is, OR must see someone pointing a gun/shooting at him/her in order to freeze his/her Assassin, OR must already be in a situation of action (i.e. being chased or stalked) in order to freeze his/her Assassin. Even if multiple people are involved, a Target may shoot at them (and, if (s)he hits his/her Assassin, freeze him/her) if it is already in a situation of action.\n\nFreezing your assassin does NOT mean (s)he can’t physically move, only that (s)he can’t try to shoot you. \n\nThe houses of the Coordinators are safe zones. The Coordinators do not want anyone claiming they took sides or set up a situation in which it was easy for an Assassin to kill his or her target. No assassinations will take place within the house of any Coordinator.\n';

const textRulesTitle5 = 'V. Safety Rules';
const textRulesContent5 =
    '\nIt is illegal for any assassinations to occur in a car. Anyone in any automobile is safe. If you are caught firing within or at any car, unless the car is a barrier and no one is inside, you will be disqualified immediately.\n\nIt is illegal to intentionally block driveways with automobiles. Blocking driveways with inanimate objects, such as garbage cans, is allowed.\n\nCar chases, at any speed, are ABSOLUTELY illegal. A car chase is defined as a situation in which the target is driving in order to CONSCIOUSLY evade the assassin and the assassin (and/or accomplices) is driving in order to continue to tail the target.\n\nLying underneath a car is strictly prohibited. Lying or sitting on top of a car while its engine is running is strictly prohibited.\n\nTargets are safe on commercial airliners. Shootouts on private planes are legal. \n\nUnderwater shootouts are illegal unless both parties have appropriate SCUBA equipment.\n\nTargets are safe while BASE jumping. Shootouts while both parties are skydiving are legal.\n\nBreaking state, federal, or local laws is against the AP Assassination rules, and doing so may result in criminal charges. \n\nCommon sense safety rules apply. If any tactic puts anyone in danger, the coordinator reserves the right to remove the player from the game.\n';

const textRulesTitle6 = 'VI. Notification';
const textRulesContent6 =
    '\nIn the event that an assassin successfully assassinates his or her target, he or she must call/text the coordinator (Daniel: 631-707-4065) as soon as possible (last day assassination notification MUST be sent no later than one hour after the round ends). The names of the assassin and target, location and time of assassination, method for assassination, and weapon used must be cited in the assassination text. If you have been confirmed as assassinated or if you fail to assassinate your target, you will not move on to the next round. We will verify with all targets that the claimed assassinations have occurred. If there is a dispute, an independent Council of Appeals will look over the case (see below).\n';

const textRulesTitle7 = 'VII. Disputes';
const textRulesContent7 =
    '\nIn the event there is an argument about an assassination, both parties should immediately text the coordinator with a detailed accounts of the incident, which will be passed on to an independent Council of Appeals, consisting of several HHH HS East alumni. They will decide the outcome of the event and institute new rules if necessary; the will of the Council is final. The names of disputing parties will be substituted with nonspecific titles to the Council (“assassin” and “target”), to ensure a fair judgment. Appeals must be submitted within 24 hours of the assassination OR 24 hours prior to the end of the Round, whichever comes first.\n\nThe more information provided in the dispute messages, the better the situation can be assessed. We encourage witness input as well, as well as video input.\n\nNote from the coordinator: please hold to honorable standards and only dispute when absolutely necessary.\n';

const textRulesTitle8 = 'VIII. Prizes';
const textRulesContent8 =
    '\nSeveral Bonus Prizes will be given out during the competition. These prizes relate to individual assassinations. The total amount of money allotted to these prizes is 12.5% of the total pot.* There will be five of them, including First Kill, Midnight Kill, Coolest Kill, Nightmare Kill, and Most Kills. All prize killings, with the exception of Most Kills, must be videotaped. \n*A prize will likely be at least double/triple your entry fee. \n\nDue to the unpredictable nature of how the final rounds will play out, it is impossible to determine definitively as of yet what the Grand Prize(s) will be. Due to this fact, this subsection is entirely tentative; all that is certain is that the overall winner(s) will get a lot of money. \n\nIf the final round has more than three assassins and only one of them moves beyond that round, it will be winner take all. \n\nIf 3 assassins make it to the final round, prizes may be given to 2nd and 3rd place. As the competition moves toward its conclusion, there will be a vote amongst the remaining 10 to 20 assassins on how the final prize should be split if the final round leaves 3 assassins facing off, whether it should still be winner take all or if 2nd and 3rd place should get some smaller prizes. \n\nIn the case of a 2 assassin final round, a decision will be agreed upon by these two assassins (and, if necessary, the coordinators and/or Council of Appeals) as to whether the money should automatically be split 50/50 or if there should be a special BONUS ROUND with special, new assignments, leaving the final prize to be split at about 75% to 25%. \n\nThe event coordinator may take up to 12.5% gratuity for scheduling, hyping up, and coordinating a successful and smoothly run event. This is a way of compensating the coordinator for their time and effort. \n';

const textRulesTitle9 = 'IX. Final Remarks';
const textRulesContent9 =
    '\nIf you are not sure if something is against the rules or if it is covered by the rules, ask the coordinators. Please always use good judgment.\n\nThese rules are subject to change at any time. Changes and clarifications will be posted to the same forum as the initial rules.\n\nIf you have not received a Target assignment by the start time of a Round, contact the coordinator IMMEDIATELY.\n';
