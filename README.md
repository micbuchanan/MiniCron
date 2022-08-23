# MiniCron

## This is MiniCron, a scheduler command line app built in Xcode 13.3.1 using Swift 5.
Given an option (`-a` - All, `-c` - Configuration, or `-h` - Help), and some data, the app returns the next scheduled 
runs of each command entered.
The app currently runs in Xcode in one of the 3 modes stated below:

### `All` data entered - option `-a`
This is the current default option, where all the required data is passed in to the `Edit Scheme > Arguments` tab in Xcode:

![Screenshot 2022-08-22 at 11 54 41](https://user-images.githubusercontent.com/8209274/186100549-192b6971-0399-4b01-b714-d8ba056701d1.png)

With this input data, when run, the app will output the following calculated schedule to Xcode's command line

![Screenshot 2022-08-22 at 12 44 08](https://user-images.githubusercontent.com/8209274/186100852-7200d7c8-6cbd-48b6-b259-85500f85e6db.png)

### `Configuration` data entered - option `-c`
In this scenario, only the configuration data needs to be entered. The app will fetch the current time automatically.
So the `Edit scheme > Arguments` tab should look like this:

![Screenshot 2022-08-22 at 11 55 22](https://user-images.githubusercontent.com/8209274/186101880-cfeb7e36-986e-40b1-8823-df4ce01904b7.png)

With this input data, when run, the app will output the calculated schedule to Xcode's command line (depending on the machines current time).

![Screenshot 2022-08-22 at 12 43 26](https://user-images.githubusercontent.com/8209274/186102177-b2cb29e8-6a1d-4778-b6dc-91ac8ea19822.png)

### `Help` mode - no data entered - option `-h`
In this scenario, given simply the option `-h`, the app will print its usage details to Xcode's command line

![Screenshot 2022-08-23 at 08 51 16](https://user-images.githubusercontent.com/8209274/186103008-a8164b73-4686-4dd4-92f3-31e77e50b839.png)

![Screenshot 2022-08-22 at 12 40 27](https://user-images.githubusercontent.com/8209274/186103125-427fa494-abac-4540-9b4d-1aa6400e9b20.png)

## Areas to improve
Given the time limitations (2 hours), the obvious areas for improvement would be:
- Enabling the app to run outside of Xcode, directly in the Terminal
- Enabling the app to run interactively in the Terminal, with prompts for the required data and formats
- Enabling the app to receive and parse the config data in a variety of formats, including `.txt` or even `.csv` files
