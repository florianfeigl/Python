#!/usr/bin/env python3

# Libraries
import csv
import numpy as np
from matplotlib import pyplot as plt


# Main function
def main():
    # Reader Settings
    StartLineFirefly = 46
    StartLineLucia = 88
    GroupCount = 5
    GroupeNum = 5

    # Plot Settings
    Categories = ["P1 unmethylated", "P1 methylated", "P5 unmethylated", "P5 methylated", "Negative Control"]
    PositionsX = np.arange(len(Categories))
    Width = 0.18  # the width of the bars
    Colors = ['blue', 'green', 'red', 'purple', 'orange']

    # Dictionaries
    GroupData = {'Firefly': [], 'Lucia': []}
    Means = {'Firefly': [], 'Lucia': []}
    Stdevs = {'Firefly': [], 'Lucia':[]}
    Normalization = {'LuciaFirefly': [], 'LuciaNegativeControl': []}

    # Lists
    LuciaFirefly = [] 
    LuciaNegative = []

    # Data Extraction Of CSV File
    with open('Luciferase_Injector_Firefly_Lucia_20231018_153036.csv') as csvFile:
        Data = csv.reader(csvFile, delimiter=',')
        Extract = list(Data)

        # Extract Firefly data
        for i in range(GroupCount):
            LineNum = StartLineFirefly + i
            GroupData['Firefly'].append([float(FireflyValue) for FireflyValue in Extract[LineNum][1:] if FireflyValue.strip()])

        # Extract Lucia data
        for i in range(GroupCount):
            LineNum = StartLineLucia + i
            GroupData['Lucia'].append([float(LuciaValue) for LuciaValue in Extract[LineNum][1:] if LuciaValue.strip()])

        # Compute mean and standard deviation for each group
        for Assay in GroupData.keys():
            for Group in GroupData[Assay]:
                CategoryMeans = []
                CategoryStdevs = []
                for i in range(0, len(Group), 4):
                    CategoryValues = Group[i:i+4]
                    CategoryMeans.append(np.mean(CategoryValues))
                    CategoryStdevs.append(np.std(CategoryValues, ddof=1))
                Means[Assay].append(CategoryMeans)
                Stdevs[Assay].append(CategoryStdevs)


        # For LuciaGroup, FiCareflyGroup 
        for LuciaDict, FireflyDict in zip(Means['Lucia'], Means['Firefly']):
            Result = np.divide(LuciaDict, FireflyDict)
            Normalization['LuciaFirefly'].append(Result)

        for LuciaDict, LuciaNegativeControl in zip(Means['Lucia'], Means['Lucia'][-1]):
            Result = np.divide(LuciaDict, LuciaNegativeControl)
            Normalization['LuciaNegativeControl'].append(Result)


        # Create Plot
        fig, axs = plt.subplots(1, 3, figsize=(18, 6))

        # Absolute Plot
        ax = axs[0]
            
        for i in range(len(GroupData['Lucia'])):
            ax.bar(PositionsX + i * Width, Means['Lucia'][i], Width, yerr=Stdevs['Lucia'][i], align='center', alpha=0.7, capsize=5, label=f'Group {i+1}', color=Colors[i])

            # Plotting individual data points
            for j, Category in enumerate(Categories):
                # Extract the 4 values for this category and group
                CategoryValues = GroupData['Lucia'][i][j*4:(j+1)*4]
                # Create x positions for the scatter plot for this group
                Jitter = Width * (np.random.rand(len(CategoryValues)) - 0.5)
                # Scatter Plot
                ax.scatter(PositionsX[j] + i * Width + Jitter, CategoryValues, s=15, color='black')

            # Adding labels
            ax.set_xlabel('Measurement')
            ax.set_ylabel('Luciferase Activity (counts/s)')
            ax.set_title('Absolute Averages')
            ax.set_xticks(PositionsX + Width, Categories, rotation=45, ha='right')
            ax.legend()


        # Normalized Plots: Lucia / Firefly
        ax = axs[1]

        for i in range(len(GroupData['Lucia'])):
            ax.bar(PositionsX + i * Width, Normalization['LuciaFirefly'][i], Width, align='center', alpha=0.7, capsize=5, label=f'Group {i+1}', color=Colors[i])

            # Adding labels
            ax.set_xlabel('Measurement')
            ax.set_ylabel('Luciferase Activity (counts/s)')
            ax.set_title('Luciferase/Firefly')
            ax.set_xticks(PositionsX + Width, Categories, rotation=45, ha='right')
            ax.legend()

            
        # Normalized Plots: Lucia / Negative Control
        ax = axs[2]

        for i in range(len(GroupData['Lucia'])):
            ax.bar(PositionsX + i * Width, Normalization['LuciaNegativeControl'][i], Width, align='center', alpha=0.7, capsize=5, label=f'Group {i+1}', color=Colors[i])

            # Adding labels
            ax.set_xlabel('Measurement')
            ax.set_ylabel('Luciferase Activity (counts/s)')
            ax.set_title('Luciferase/Negative Control')
            ax.set_xticks(PositionsX + Width, Categories, rotation=45, ha='right')
            ax.legend()

        plt.suptitle('Average Luciferase Activity')
        plt.tight_layout()
        plt.show()

# Execute main function
if __name__ == '__main__':
    main()
