/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ueb01;

/**
 * TODO DONE Javdoc Kommentar
 * hallo marko 8)
 * checks if numbers from START to END are harshad, how many collatz-steps
 * are required, calculates the digit-sum and encrypts the numbers (via XOR)
 * with the key "key" if the key is valid (8-bit range)
 * also prints stuff on stdout ofc.
 * 
 * @author iam102916, iat103971
 */
public class Grp31_ueb01 {
    static String binString = "";
    /**
     * TODO DONE Javadoc
     * defines START and END and key
     * calls getMaxLength to determine output format
     * runs from START to END and
     * calls printOutput to print output..
     * also checks if key is valid
     * 
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        final int START = -4;
        final int END = 3;
        int key = 5;

        int WIDTH = getMaxLength(START, END);

        System.out.printf("Untersucht werden Zahlen zwischen %d und %d\n", START, END);
        if (isValidKey(key)) {
            System.out.printf("Schlüssel = %s (%d)\n", printIntBinaer(key), key);
        } else {
            System.out.printf("WARNUNG: Verschlüsselung nicht möglich, ungültiger Schlüssel = %s (%d)\n", 
                    printIntBinaer(key), key);
        }

        for (int i = START; i <= END; i++) {
            printOutput(i, key, isValidKey(key), WIDTH);
        }
    }
    

    /**
     * determines length of num ('-12' returns 3, '5' returns 1)ount + 1))
     *
     * @param num integer
     * @return length of num
     */
    private static int calcNumLength(int num) {
        int len = 1;
        if (num < 0) {
            len++;
            num *= -1;
        }
        while (num >= 10) {
            len++;
            num /= 10;
        }
        return len;
    }

    /**
     * gets max length between num1 and num2 /also see calcNumLength
     *
     * @param num1 first integer
     * @param num2 second integer
     * @return highest length
     */
    private static int getMaxLength(int num1, int num2) {
        return calcNumLength(num1) > calcNumLength(num2) ? calcNumLength(num1) : calcNumLength(num2);
    }

    /**
     * determines the digit sum of num.
     * negative numbers are calculated as if positive, 
     * but with '-' (this is not a smiley)
     * TODO DONE Was passiert für negative Zahlen
     *
     * @param num integer
     * @return digit sum of num
     */
    private static int digitSum(int num) {
        int sum = 0;

        int len = calcNumLength(num);
        for (int i = 1; i <= len; i++) {
            sum += num % 10;
            num /= 10;
        }
        return sum;
    }

    /**
     * determines if key is valid (8-bit range)
     *
     * @param key given key
     * @return TRUE if key is valid/else FALSE
     */
    static boolean isValidKey(int key) {
        return key != 0 && ((key >>= 8) == 0);
    }

    /**
     * determines if num is a harshad number
     *
     * @param num integer number
     * @return TRUE if num is a harshad number/else FALSE
     */
    private static boolean harshAd(int num) {
        if (num != 0) {
            return (num % digitSum(num) == 0);
        } else {
            return false;
        }
    }

    /**
     * calculates required collatz steps of num
     *
     * @param num integer number to be investigated
     * @param count used because you wanted this to be recursive. Call with 0
     * @return collatz steps of num
     */
    private static int collatz(int num) {
        //TODO DONE Parameter nur die Zahl
        if (num <= 0) {
            return -1;
        } else if (num == 1) {
            return 0;
        } else {
            return collatz(((num % 2) == 0) ? num / 2 : (num * 3 + 1) )+1;
        }
    }

    /**
     * Uses an integer to convert it into a string containing its binary values
     *
     * @param num integer to be converted
     * @return integer in binary code as string
     */
    private static String printIntBinaer(int num) {
        String tanga = "";
        int del = 0;
        for (int i = 31; i >= 0; i--) {
            if ((num & (1 << i)) != 0) {
                tanga += '1';
            } else {
                tanga += '0';
            }
        }

        while (tanga.charAt(del) == '0' && (tanga.length() - 1 > del)) {
            tanga = tanga.replaceFirst("0", " ");
            del++;

        }
        tanga = tanga.trim();
        return tanga;//or what's left of it ( ͡° ͜ʖ ͡°)
    }

    /**
     * applies key to num via xor
     *
     * @param num integer to be encoded
     * @param key key with which to encode
     * @return encoded num
     */
    private static int encryptionXOR(int num, int key) {
        for (int i = 0; i < 4; i++) {
            num = num ^ key;
            key <<= 8;
        }
        return num;
    }

    /**
     * Prints stuff according to your bullshit.
     *
     * @param num integer number..
     * @param key integer key for encryption (between 0 and 255)
     * @param validK to slightly reduce iNeFfiCiEnCy
     * @param width width of num.. also reduce iNeFfiCiEnCy
     */
    private static void printOutput(int num, int key, boolean validK, int width) {

        //first line
        System.out.printf("%" + width + "d: Quersumme = %2d", num, digitSum(num));
        if (collatz(num) != (-1)) {
            System.out.printf(", Collatz-Schritte = %3d", collatz(num));
        }
        if (harshAd(num)) {
            System.out.printf(", Harshad-Zahl");
        }
        System.out.printf("\n");

        //second line
        if (validK) {
            //bEcAuSe InEfFiCiEnCy YoU kNOoOwW?
            for (int i = 0; i <= width + 1; i++) {
                System.out.printf(" ");
            }
            System.out.printf("Verschlüsselung = %32s (%11d)\n", 
                    printIntBinaer(encryptionXOR(num, key)), encryptionXOR(num, key));
        }
    }
}
