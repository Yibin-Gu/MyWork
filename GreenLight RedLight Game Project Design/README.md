# Project Introduction
During this quarter, we were tasked with creating a game that includes elements of speech recognition, gesture recognition, and localization/position detection. We decided to implement a Red Light-Green Light based game which would include questions during the red lights and a pose detection at the end of the game.
   
We used a Raspberry Pi Zero W and a laptop as the controlling entities. 

>The laptop acted as a master to the Pi using TCP communication. 

>The Pi ran the sensors measuring player distances and the led output of the signal (red or green). 

>The laptop ran the main game prompts, voice recognition, and gesture recognition.

### What I did in this poject
#### Handing Gesture Recognition Part
- By using **OpenPose**, a open-source to collect data of body gestures. 
![DataCollection](https://github.com/Yibin-Gu/MyWork/blob/master/GreenLight%20RedLight%20Game%20Project%20Design/For%20Intro/CollectingData.gif)
>Noticed that in our project, we only used half of the body key-points from the collecting data, so first we need to cut the collected data into half.

- Trained data by using **Jupyter NoteBooks**. Along with Python super tools like **Numpy** and **Keras** to give us a staightforward way to observe, clean, and train a neural network on data.

![TraningData](https://github.com/Yibin-Gu/MyWork/blob/master/GreenLight%20RedLight%20Game%20Project%20Design/For%20Intro/TrainingData.png)

#### Putting the Pieces Together, and Testing it
- Participate in the construction of the main code, integrate all the content into one piece and test.

  In the test, we found the instability of Win10 system to multiple Bluetooth microphones and decided to use the single microphone with better radio effect to play the game in the end.


#### For more information
- [Our Project Report.pdf](<https://docs.google.com/document/d/1CvcAzP3TFHF5Jm2mHNT7q_Pd7IH8BGOfWNovb5iShsk/edit?usp=sharing>)
- [OpenPose](<https://https://github.com/CMU-Perceptual-Computing-Lab/openpose>)
    
