//
//  def.h
//  LastSupper
//
//  Created by 清水 一征 on 12/10/31.
//  Copyright (c) 2012年 momiji-mac.com. All rights reserved.
//

#ifndef LastSupper_def_h
#define LastSupper_def_h

#define ILLEGULAR_NUMBER        10000

#define CELL_Height             60;
#define LOG_METHOD_NAME         NSLog(@"method name is %@", NSStringFromSelector(_cmd));
#define LOG_ERROR_METHOD        NSLog(@"error at %@", NSStringFromSelector(_cmd));

#define INDEX_DATE              0
#define INDEX_DIET              1

#define RGBA(r, g, b, a) [UIColor colorWithRed : (r) / 255.0 green : (g) / 255.0 blue : (b) / 255.0 alpha : (a)]
#define RGB(r, g, b)     [UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : 1]

//pie chart color
#define BASE_R                  255
#define BASE_G                  235
#define BASE_B                  202

//Label color
#define    LABEL_RED            200
#define    LABEL_GREEN          200
#define    LABEL_BLUE           200

#define NORMAL_FACE             @"facemark_non.png"
#define GOOD_FACE               @"facemark_good.png"
#define BAD_FACE                @"facemark_bad.png"

#define MORNINING               @"morning"
#define LUNCH                   @"lunch"
#define DINNER                  @"dinner"

#define ITEMS                   @"ngb"

#define TIME_1_24_HOUR          0.042 // 1/24

#define FIRST_Object_OF_NSArray 0

//時間区分
#define LUNCH_TIME              12
#define DINNER_TIME             19

#define DIET_TIMES_aDAY         3 //一日３食

// color
#define SATURATION_START        0.1
#define SATURATION_END          0.16
#define BRIGHTNESS              1.0

// animation
#define ANIMATE_DUTATION        1.5f
#define ANIMATE_DELAY           0.2f

// back date
#define BACKDATE_MAX            -90

typedef enum {
    normal_ITEM = 0,
    good_ITEM,
    bad_ITEM,
    max_ITEM
}DIETITEM;

typedef enum {
    minTag = 0,
    morningTag,
    lunchTag,
    dinnerTag,
    maxTag
}DIET_TAGS;

typedef enum {
    Order_base = 0,
    Order_morning,
    Order_lunch,
    Order_dinner,
    Order_MAX
}IMAGE_ORDER;

typedef enum {
    INDEX_BIRTH = 0,
    INDEX_DIE,
    INDEX_MAX
}INDEX_Segment;

typedef NS_ENUM (NSInteger, ACTION) {
    ACT_PHOT = 0,
    ACT_LIB,
    ACT_TAP,
    ACT_MAX
};

//generation
#define gene_min      10
#define    gene_YOU   100
#define    gene_JYAKU 200
#define    gene_SOU   300
#define    gene_KYOU  400
#define    gene_GAI   500
#define    gene_KI    600
#define    gene_ROU   700
#define    gene_MOU   800

typedef NS_ENUM (NSInteger, GENERATION_Tag) {
    geneTag_min    = 0,
    geneTag_10_you =  1,
    geneTag_20_jyaku,
    geneTag_30_sou,
    geneTag_40_kyou,
    geneTag_50_gai,
    geneTag_60_ki,
    geneTag_70_rou,
    geneTag_80_mou,
    geneTag_max
};

#define THUMIMAGE_SIZE       75
#define SMALL_THUMIMAGE_SIZE 38

#define LIB                  @"lib"
#define CAMERA               @"camera"

//for NSData
#define DATE_EDIT            @"_DATE_"
#define MORNING_EDIT         @"_morning_"
#define LUNCH_EDIT           @"_lunch_"
#define DINNER_EDIT          @"_dinner_"
#define BIRTH_EDIT           @"_birth_"
#define DIE_EDIT             @"_die_"
#define T_MORNING_EDIT       @"t_morning_"
#define T_LUNCH_EDIT         @"t_lunch_"
#define T_DINNER_EDIT        @"t_dinner_"

#endif
