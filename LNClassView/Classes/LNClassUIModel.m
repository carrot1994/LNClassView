//
//  LNClassUIModel.m
//  LiNingApp
//
//  Created by carrot on 2020/11/20.
//

#import "LNClassUIModel.h"

#define ComPareFloatValue(A,B) A > 0 ? A : B
#define ComPareFrameValue(A,B) A.size.width > 0 ? A : B
#define ComPareSizeValue(A,B) A.width > 0 ? A : B

#define ComPareInsetValue(A,B)     ( [[NSValue valueWithUIEdgeInsets:A] isEqualToValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero]]) ? A : B

#define ComPareValue(A,B) A ? A : B

@implementation LNClassUIModel


- (void)updateConfigModel:(LNClassUIModel *)model {


    self.rightCellSize = ComPareSizeValue(model.rightCellSize,self.rightCellSize);
    self.sectionTitleSize = ComPareSizeValue(model.sectionTitleSize,self.sectionTitleSize);
    self.minimumInteritemSpacing = ComPareFloatValue(model.minimumInteritemSpacing, self.minimumInteritemSpacing);
    self.minimumLineSpacing = ComPareValue(model.minimumLineSpacing, self.minimumLineSpacing);

    self.insetForSection = ComPareInsetValue(model.insetForSection, self.insetForSection);
    self.titleViewSize = ComPareSizeValue(model.titleViewSize,self.titleViewSize);
    self.titleFont = ComPareValue(model.titleFont, self.titleFont);
    self.titleSelectedFont = ComPareValue(model.titleSelectedFont, self.titleSelectedFont);
    self.selectedTitleColor = ComPareValue(model.selectedTitleColor, self.selectedTitleColor);
    self.titleColor = ComPareValue(model.titleColor, self.titleColor);
    self.lineVerticalMargin = ComPareFloatValue(model.lineVerticalMargin, self.lineVerticalMargin);
    self.lineIndicatorSize = ComPareSizeValue(model.lineIndicatorSize, self.lineIndicatorSize);
    self.ineindicatorColor = ComPareValue(model.ineindicatorColor, self.ineindicatorColor);
    self.lineindicatorCornerRadius = ComPareFloatValue(model.lineindicatorCornerRadius, self.lineindicatorCornerRadius);


}

@end
