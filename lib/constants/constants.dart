import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*   Main   */
const appTitle = 'AP Assassin';

/*   Color Scheme   */

/*
// Light Scheme
const kWhiteColor = Color(0xFFFAFAFA);
const kBlackColor = Color(0xFF383A42);
const kGreyColor = Color.fromARGB(255, 240, 240, 240);
const kDarkGreyColor = Color.fromARGB(255, 119, 119, 119);
const kRedColor = Colors.red;
const kErrorColor = Colors.orange;
const kBlueColor = Color.fromARGB(255, 64, 120, 242);
const kCyanColor = Color.fromARGB(255, 1, 132, 188);
*/

// Dark Scheme
const kBlackColor = Color(0xff282c34);
const kWhiteColor = Color(0xffabb2bf);
const kGreyColor = Color(0xff5c6370);
const kDarkGreyColor = Color(0xff4b5263);
const kRedColor = Color(0xffe06c75);
const kPurpleColor = Color(0xffc678dd);
const kGreenColor = Color(0xff98c379);
const kOrangeColor = Color(0xffd19a66);
const kBlueColor = Color(0xff61afef);
const kCyanColor = Color(0xff56b6c2);

/*   Text Formatting Section   */

// Status Bar Formatting
const statusBarColorAlt = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light);
const statusBarColorMain = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark);

// General Formatting
const heading = TextStyle(
    color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 30, height: 1.5);
const smallerHeading = TextStyle(
    color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 20, height: 1.5);

const buttonInfo =
    TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 15);

const generalText =
    TextStyle(color: kWhiteColor, fontWeight: FontWeight.normal, fontSize: 15);
const hintText =
    TextStyle(color: kGreyColor, fontWeight: FontWeight.normal, fontSize: 15);
const redOptionText =
    TextStyle(color: kRedColor, fontWeight: FontWeight.bold, fontSize: 15);

// Button Styles
final rectButton = ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(
      const BeveledRectangleBorder(),
    ),
    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
    foregroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
    backgroundColor: MaterialStateProperty.all<Color>(kGreyColor),
    side: MaterialStateProperty.all<BorderSide>(BorderSide.none));
final underlinedButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(kWhiteColor),
    backgroundColor: MaterialStateProperty.all<Color>(kBlackColor),
    side: MaterialStateProperty.all<BorderSide>(BorderSide.none));
final redButton = ButtonStyle(
    shape: MaterialStateProperty.all<OutlinedBorder>(
        const BeveledRectangleBorder()),
    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
    foregroundColor: MaterialStateProperty.all<Color>(kBlackColor),
    backgroundColor: MaterialStateProperty.all<Color>(kRedColor),
    side: MaterialStateProperty.all<BorderSide>(BorderSide.none));

// Popup Formatting
const popupTitle = TextStyle(
    color: kWhiteColor, fontWeight: FontWeight.normal, fontSize: 24.0);
const popupText = TextStyle(
    color: kWhiteColor, fontWeight: FontWeight.normal, fontSize: 20.0);

// Home Page Formatting
const homeBlurb = TextStyle(
    color: kWhiteColor,
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.2);

// Kill Page Formatting
const killHeadings = TextStyle(
    color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 30, height: 1.5);

// Rules Page Formatting

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
const textLogoutCheck = 'Are you sure you want to ';

// People Text
const textShowAlive = 'Remaining Players';
const textShowAll = 'All Players';
const textShowAdmin = 'Coordinators';
const textShowUnverified = 'Unverified';

const textSortAZ = 'A - Z';
const textSortZA = 'Z - A';
const textSortKills = 'Most Kills';

// Rules Text
const textRulesSectionTemp = 'New Rules Section';
const textRulesBodyTemp = 'New Rules';

// Hints Text
const textSaveButton = 'SAVE';
const textHintMessage = 'Hint Message';
