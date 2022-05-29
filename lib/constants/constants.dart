import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*   Main   */
const appTitle = 'AP Assassin';

/*   Color Scheme   */
const kPrimaryColor = Colors.white;
const kBlackColor = Colors.black;
const kGreyColor = Color.fromARGB(255, 240, 240, 240);
const kDarkGreyColor = Color.fromARGB(255, 119, 119, 119);
const kRedColor = Colors.red;
const kErrorColor = Colors.orange;
const kBlueGreenColor = Color.fromARGB(255, 47, 169, 118);
const kMidRedGreyColor = Color.fromARGB(255, 236, 187, 187);

/*   Text Formatting Section   */

// Status Bar Formatting
const statusBarColor = SystemUiOverlayStyle(
    statusBarColor: kPrimaryColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light);
const statusBarColorScroll = SystemUiOverlayStyle(
    statusBarColor: kPrimaryColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light);

// General Formatting
const heading = TextStyle(
    color: kBlackColor, fontWeight: FontWeight.bold, fontSize: 30, height: 1.5);
const buttonInfo =
    TextStyle(color: kBlackColor, fontWeight: FontWeight.bold, fontSize: 15);

// Popup Formatting
const popupTitle = TextStyle(
    color: kBlackColor, fontWeight: FontWeight.normal, fontSize: 24.0);
const popupText = TextStyle(
    color: kBlackColor, fontWeight: FontWeight.normal, fontSize: 20.0);

// Home Page Formatting
const homeBlurb = TextStyle(
    color: kBlackColor,
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.2);

// Kill Page Formatting
const killHeadings = TextStyle(
    color: kBlackColor, fontWeight: FontWeight.bold, fontSize: 30, height: 1.5);
final killButton = ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(
      const BeveledRectangleBorder(),
    ),
    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
    foregroundColor: MaterialStateProperty.all<Color>(kBlackColor),
    backgroundColor: MaterialStateProperty.all<Color>(kGreyColor),
    side: MaterialStateProperty.all<BorderSide>(BorderSide.none));

// Rules Page Formatting
final rulesButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(kBlackColor),
    backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
    side: MaterialStateProperty.all<BorderSide>(BorderSide.none));

/*   Set Text   */

// General Text
const textStart = 'Get Started';
const textLogin = 'Sign In';
const textSignUp = 'Sign Up';
const textProceed = 'Proceed';
const textCancel = 'Cancel';
const textLoading = 'Loading';

// Login Text
const textLoginTitle = 'Welcome back!';
const textLoginSubtitle = 'The hunt continues ...';
const textNoAcc = "Don't have an account? ";

// Register Text
// const textRegisterTitle = 'Create your account!';
// const textRegisterSubtitle = 'And let the games begin';
const textHaveAcc = "Already have an account? ";

const textHintEmail = 'Enter email';
const textHintPass = 'Set password';
const textHintConfirm = 'Confirm password';

// Auth Error Text
const textErrorNoMatch = '  Password must match';
const textErrorWeakPassword = '  Weak password';
const textErrorUserExists = '  Email taken';
const textErrorInvalidEmail = '  Invalid email address';
const textErrorWrongPassword = '  Wrong Password';
const textErrorWrongEmail = '  No user with this email';
const textErrorMissingFields = '  At least one field is empty';

// Info Text
const textInfoTitle = 'Almost there';
const textInfoSubtitle = 'Enter some personal info';
const textInfoPhoto = 'Submit a clear photo of your face';
const textChoosePhoto = '  Select';
const textTakePhoto = '  Capture';

const textHintFullName = 'Enter full name';
const textHintPhoneNumber = 'Enter phone number';
const textHintNumberAPs = 'Enter # of APs taken';

// Game Choice Text
const textAdmin = '  Coordinator';
const textPlayer = '  Participant';
const textEnterGame = 'Enter Game';
const textSearch = 'Search Game';
const textJoinGame = 'Search Game';
const textCreateGame = 'Start New Game';
const textNewGameName = 'Choose New Name';

const textErrorNoType = '  No account type chosen';
const textErrorNoGame = '  No game chosen';

// Verify Text
const textRegisterSuccess =
    'You have successfully registered for Hills East AP Assassin';
const textVerification1 = 'Your account will now be manually verified';
const textVerification2 = 'This process should not take more than 24 hours';
const textVerification3 =
    'Contact your coordinator with any questions or issues';

// Logout Text
const textLogout = 'Log Out';
const textLogoutCheck = 'Are you sure you want to log out?';

// People Text
const textShowAlive = 'Remaining Players';
const textShowAll = 'All Players';
const textShowAdmin = 'Coordinators';

const textSortAZ = 'A - Z';
const textSortZA = 'Z - A';
const textSortKills = 'Most Kills';

// Rules Text
const textRulesSectionTemp = 'New Rules Section';
const textRulesBodyTemp = 'New Rules';
