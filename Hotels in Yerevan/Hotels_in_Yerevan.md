Hotels in Yerevan
================
Hermine Grigoryan
15 August, 2018

The data for the analysis was scraped from TripAdvisor. It contains information about Yerevan hotels, i.e. their prices, number of reviews, providers and other details. Several types of plots were used for visualizing the data. I used **martirossaryan** package to give colors to the plots.

### Step 1: Cleaning and preparing the data

``` r
library(ggplot2)
library(dplyr)
library(stringr)
library(martirossaryan)
library(ggpubr)
library(ggrepel)
library(knitr)

data<-read.csv("final_data.csv", stringsAsFactors = F)
data[, c(2, 4:10)]<-as.data.frame(apply(data[, c(2, 4:10)], 2, as.factor))
str(data)
```

    ## 'data.frame':    197 obs. of  15 variables:
    ##  $ Hotel             : chr  "ibis Yerevan Center Hotel" "Deluxe Hotel Yerevan" "Armenia Marriott Hotel Yerevan" "Tufenkian Historic Yerevan Hotel" ...
    ##  $ Provider          : Factor w/ 4 levels "Agoda.com","Booking.com",..: 2 1 2 2 1 2 3 2 1 2 ...
    ##  $ Review_Count      : int  209 226 743 382 622 145 344 171 599 311 ...
    ##  $ Free_Wifi         : Factor w/ 2 levels "0","1": 2 2 1 2 2 2 2 2 2 2 ...
    ##  $ Breakfast_Included: Factor w/ 2 levels "0","1": 1 1 1 2 2 1 1 1 1 1 ...
    ##  $ Swimming_Pool     : Factor w/ 2 levels "0","1": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Free_Parking      : Factor w/ 2 levels "0","1": 2 2 2 1 1 2 2 2 2 2 ...
    ##  $ Website           : Factor w/ 2 levels "0","1": 2 2 2 1 2 1 2 1 1 2 ...
    ##  $ Special_Offer     : Factor w/ 2 levels "0","1": 2 2 2 1 2 1 1 1 1 2 ...
    ##  $ Restaurant        : Factor w/ 2 levels "0","1": 1 1 2 1 1 1 1 1 1 1 ...
    ##  $ links             : chr  "https://www.tripadvisor.com/Hotel_Review-g293932-d11665411-Reviews-Ibis_Yerevan_Center_Hotel-Yerevan.html" "https://www.tripadvisor.com/Hotel_Review-g293932-d1479879-Reviews-Deluxe_Hotel_Yerevan-Yerevan.html" "https://www.tripadvisor.com/Hotel_Review-g293932-d299732-Reviews-Armenia_Marriott_Hotel_Yerevan-Yerevan.html" "https://www.tripadvisor.com/Hotel_Review-g293932-d3634113-Reviews-Tufenkian_Historic_Yerevan_Hotel-Yerevan.html" ...
    ##  $ Price_AMD         : int  24750 14021 54400 37000 46268 22342 35547 28875 33408 37500 ...
    ##  $ Price_USD         : int  51 29 112 76 96 46 73 60 69 77 ...
    ##  $ overall_rating    : num  4.5 4.5 4 4.5 4.5 4.5 4.5 4.5 4 4.5 ...
    ##  $ address           : chr  "Northern Avenue 5/1, Yerevan 0001, Armenia" "Komitas ave 32, Yerevan 0012, Armenia" "Amiryan str. 1, Yerevan 0010, Armenia" "Anrapyetutsyan str. 48, Yerevan 0010, Armenia" ...

``` r
data$Hotel<-str_remove_all(data$Hotel, "Yerevan")
data$Hotel<-str_remove_all(data$Hotel, "[:punct:]")
data$Hotel<-str_replace_all(data$Hotel, "DoubleTree by Hilton Hotel  City Centre", "DoubleTree by Hilton")
data$Hotel<-str_replace_all(data$Hotel, "The Alexander Hotel a Luxury Collection Hotel ", "The Alexander")
data$Hotel<-str_remove_all(data$Hotel, "Hotel")

data$Hotel<-trimws(data$Hotel)
```

``` r
#Some functions

#A function for Saryan's Palettes which also takes into account how many color palettes to pick
SaryanPalette<-function(picture_name, number){
  palette<-getSaryanPallete(picture_name)
  palette<-palette[1:number]
  return(palette)
}

#A function for having nice scales (scale_y_continuous)
number_ticks <- function(n) {function(limits) pretty(limits, n)}

#A function for violins
data_summary <- function(x) {
  m <- mean(x)
  ymin <- m-sd(x)
  ymax <- m+sd(x)
  return(c(y=m,ymin=ymin,ymax=ymax))
}

#Theme for the graphs
tema<-theme(panel.background = element_rect(fill="white"),
            panel.grid = element_line(color="#ccccff", size=0.09),
            title = element_text(face="italic", size=12),
            axis.text = element_text(face = "italic", size=11))
```

The Most Expensive Hotels in Yerevan
------------------------------------

``` r
data %>%
  arrange(desc(Price_USD)) %>%
  head(10) %>%
  ggplot(aes(x=reorder(Hotel, Price_USD), y=Price_USD))+geom_bar(stat="identity",
                                                    fill=SaryanPalette("armenia", 10))+
  coord_flip()+tema+
  scale_color_manual(values = SaryanPalette("armenia", 10))+
  scale_y_continuous(breaks=number_ticks(10))+
  labs(title="Top 10 Hotels with the Highest Price", y="Price (USD)", x="Hotel")
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-3-1.png)

Of all Yerevan hotels, the most expensive one is The Alexander hotel, as can be seen in the barplot. The price on the plot indicates the average price for one room for two adults. It is interesting to note that The Alexander hotel is twice as expensive as the next hotel room on the plot.

The Most Reviewed Hotels in Yerevan
-----------------------------------

``` r
data %>%
  arrange(desc(Review_Count)) %>%
  head(10) %>%
  ggplot(aes(x=reorder(Hotel, Review_Count), y=Review_Count))+geom_bar(stat="identity",                                                fill=SaryanPalette("egyptian-night", 10))+
  scale_fill_manual(values=SaryanPalette("egyptian-night", 10))+
  coord_flip()+tema+
  scale_y_continuous(breaks=number_ticks(10))+
  labs(title="Top 10 Hotels with Most Number of Reviews", y="Number of Reviews", x="Hotel")
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-4-1.png)

This barplot shows the top 10 hotels with the biggest number of reviews. Armenia Marriott is the Yerevan branch of the hotels chain and tops this list. It is one of the most well-known hotels and can be expected to have a high number of reviews. Some of the relatively newer hotels in Yerevan - Double Tree by Hilton and Hyatt Place - have remarkably been working productively to gain many reviews to appear in this top 10.

How the Price and the Number of Reviews are Interconnected
----------------------------------------------------------

``` r
ggplot(data, aes(Review_Count, Price_USD))+geom_point(color="#7f7fff", size=2)+
  scale_y_continuous(breaks=number_ticks(10))+
  scale_x_continuous(breaks=number_ticks(10))+
  labs(title="Relationship Between Price and Number of Reviews", y="Price (USD)", 
       x="Number of Reviews")+tema
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-5-1.png)

This scatterplot shows the relationship between the price for one room for 2 adults and the number of reviews the hotel has. From this illustration we cannot claim that the price has a significant effect on the number of reviews the hotel has. The two variables are not highly correlated.

Are the Prices for Each Provider Different? - Boxplot
-----------------------------------------------------

``` r
ggplot(data, aes(x=Provider, y=Price_USD))+geom_boxplot(aes(fill=Provider))+
  scale_y_continuous(breaks=number_ticks(10))+
  scale_fill_manual(values=SaryanPalette("love", 4))+tema+theme(legend.position = "none")+
  labs(title="Distribution of Price per Each Provider",
       x="Provider", y="Price (USD)")+
  geom_text_repel(data=subset(data, Price_USD>140), aes(label=data[data$Price_USD>140, "Hotel"]))
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-6-1.png)

The boxplot above shows that the prices of each provider do not differ significantly from each other. The provider of the most expensive hotel in Yerevan is Expedia.com. The medium price for the hotels in Yerevan is 40 USD. The provider with the most unusual prices is Booking.com. However, along with looking at the boxplot for finding outliers, we shouldn't also forget if the data is balanced for each provider. Let's see how frequent each of the providers appear in list of Yerevan hotel providers.

``` r
kable(table(data$Provider), format = "markdown", col.names = c("Provider", "Frequency"),
      caption = "The Frequency of Hotel Providers")
```

| Provider    |  Frequency|
|:------------|----------:|
| Agoda.com   |         13|
| Booking.com |        155|
| Expedia.com |         27|
| Hotels.com  |          2|

We see that the most frequent hotel provider is Booking.com. That is why it has the most number of outliers.

Are the Prices for Each Provider Different? - Violin
----------------------------------------------------

Now, let's analyze the same data with a different type of a graph - violin.

``` r
ggplot(data, aes(x=Provider, y=Price_USD))+geom_violin(trim=FALSE, 
                                                       aes(fill=Provider))+
  scale_y_continuous(breaks=number_ticks(10))+
  scale_fill_manual(values=SaryanPalette("love", 4))+
  stat_summary(fun.data=data_summary)+tema+theme(legend.position = "none")+
  labs(title="Distribution of Price per Each Provider",
       x="Provider", y="Price (USD)")
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-8-1.png)

This type of a graph shows the same picture, along with the distribution of the data.

Distribution of Price
---------------------

``` r
ggplot(data, aes(x=Price_USD))+geom_histogram(bins=50, color="blue", fill="lightblue")+
  scale_y_continuous(breaks=number_ticks(10))+
  scale_x_continuous(breaks=number_ticks(10))+
  labs(title="Distribution of Price", x="Price (USD)", y="Frequency")+
  tema
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-9-1.png)

This histogram shows a right-skewed distribution of prices. The most frequent prices are in a range of 10 - 60. The Alexander hotel is a far outlier as can be seen.

Frequency of Ratings
--------------------

``` r
data$overall_rating<-as.factor(data$overall_rating)
data %>%
  group_by(overall_rating) %>%
  summarise(count=n()) %>%
  na.omit() %>%
  ggplot(aes(reorder(overall_rating, count), count))+geom_bar(stat="identity",
                                                              fill=SaryanPalette("flowers-from-chamlych", 9))+
  scale_fill_manual(values=SaryanPalette("flowers-from-chamlych", 9))+
  coord_flip()+tema+
  labs(title="Frequency of Ratings for All Hotels", y="Frequency", x="Rating")
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-10-1.png)

This barplot shows the top frequent ratings for all the hotels. There are more than 50 hotels with a rating of 4.5. Fewer hotels have the highest rating - 5.

Distribution of Price per each Rating
-------------------------------------

``` r
ggplot(na.omit(data), aes(x=reorder(overall_rating, Price_USD), y=Price_USD))+geom_boxplot(aes(fill=overall_rating))+
  scale_y_continuous(breaks=number_ticks(10))+
  scale_fill_manual(values=SaryanPalette("grapes", 9))+tema+theme(legend.position = "none")+
  labs(title="Distribution of Price per Each Rating",
       x="Rating", y="Price (USD)")+
  geom_text_repel(data=subset(data, Price_USD>119), aes(label=data[data$Price_USD>119, "Hotel"]))+
  coord_flip()
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-11-1.png)

``` r
ggplot(na.omit(data), aes(x=reorder(overall_rating, Price_USD), y=Price_USD))+geom_violin(trim=FALSE, aes(fill=overall_rating))+
  scale_y_continuous(breaks=number_ticks(10))+
  scale_fill_manual(values=SaryanPalette("grapes", 6))+
  stat_summary(fun.data=data_summary)+tema+theme(legend.position = "none")+
  labs(title="Distribution of Price per Each Rating",
       x="Rating", y="Price (USD)")+
  coord_flip()
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-11-2.png)

The boxplot and the violin above show the distribution of price for each rating. There are not many outliers for ratings. We see that *The Alexander* and *Hyatt Place*, the most expensive hotels, have the rating of 4.5. Hotel *Golden Palace Boutique* has the highest rating of 5, with a relatively low price.

How many hotels have the following services?
--------------------------------------------

``` r
details<-as.data.frame(rbind(Wifi=nrow(data[data$Free_Wifi=="1",]), Breakfast=nrow(data[data$Breakfast_Included=="1",]),
                          Swimming_Pool=nrow(data[data$Swimming_Pool=="1",]),
                          Parking=nrow(data[data$Free_Parking=="1",]),
                          Website=nrow(data[data$Website=="1",]),
                          Special_Offer=nrow(data[data$Special_Offer=="1",]),
                          Restaurant=nrow(data[data$Restaurant=="1",])))
colnames(details)<-"W"
details$labels<-rownames(details)

ggplot(details, aes(x=reorder(labels, W), y=W))+geom_bar(stat="identity", fill=SaryanPalette("egyptian-night", 7))+
  scale_fill_manual(values=SaryanPalette("egyptian-night", 7))+
  scale_y_continuous(breaks=number_ticks(10))+
  coord_flip()+tema+
  labs(title="Number of Holets with Mentioned Services", y="Number of Hotels", x="Service")
```

![](Hotels_in_Yerevan_files/figure-markdown_github/unnamed-chunk-12-1.png)

As the barplot shows, most of the hotels (119 from 197) have access WiFi. Around 95 of the hotels have free parking. In 16 of them breakfast is included. No more than 6 of the hotels have official website, swimming pool and restaurant. 5 of the hotels have special offers.
