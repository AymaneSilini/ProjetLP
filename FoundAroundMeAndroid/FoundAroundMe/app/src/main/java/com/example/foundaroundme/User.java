package com.example.foundaroundme;

import java.util.Date;

/**
 * Class user is use like globale class is stock in the application the data of user. Is create when the user login application and the application
 * use firecloud to have the data or when he/she create account
 * @version 1.0
 */
public final class User {
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String pseudo;
    private Date dateCreation;
    private String channel;

    //  Constructor

    /**
     * Constructor if User() initialise the atribut for this class
     */

    public User() {
        this.firstName = "firstName";
        this.lastName = "lastName";
        this.email = "email";
        this.password = "password";
        this.pseudo = "pseudo";
        this.dateCreation = new Date(1900, 00, 11);
        this.channel = "Général";
    }


    // Assessor

    /**
     * Assessor to change the first name
     * @param firstName
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     * Assessor to change the last name
     * @param lastName
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    /**
     * Assessor to change the email
     * @param email
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Assessor to change the password
     * @param password
     */
    public void setPassword(String password) {
        this.password = password;
    }

    public void setChannel(String s){
        this.channel = s;
    }

    /**
     * Assessor to change the pseudo
     * @param pseudo
     */
    public void setPseudo(String pseudo) {
        this.pseudo = pseudo;
    }

    /**
     * Assessor to change the creation date
     * @param dateCreation
     */
    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }

    /**
     * Assessor to get the first name
     * @return firstName
     */
    public  String getFirstName() {
        return firstName;
    }
    /**
     * Assessor to get the last name
     * @return lastName
     */
    public String getLastName() {
        return lastName;
    }
    /**
     * Assessor to get the email
     * @return email
     */
    public String getEmail() {
        return email;
    }
    /**
     * Assessor to get the password
     * @return password
     */
    public String getPassword() {
        return password;
    }
    /**
     * Assessor to get the pseudo
     * @return pseudo
     */
    public String getPseudo() {
        return pseudo;
    }
    /**
     * Assessor to get the creation date
     * @return dateCreation
     */
    public Date getDateCreation() {
        return dateCreation;
    }

    public String getChannel(){return this.channel;}

}
