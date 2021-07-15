
##############################################################################
#                                                                            #
#                               Shiny Server                                 #
#                                                                            #
##############################################################################
### Begin server ---------------------------------------------------------------

shinyServer(function(input, output, session) {
  
  observeEvent(input$dist, {
    # This function checks, whether the selected distribution is changed by the
    # users input and disables the drawing of the rejection area if so.
    updateCheckboxInput(session, 'crit.value.checkbox', value = F)
    updateSliderInput(session, "distquant", value = "Keine")
  }) # END observeEvent
  
  ### Distributions plots including rejection areas ----------------------------
  
  output$plot <- renderPlot({
    
    if (!is.null(input$dist)) {
      
      uniblue <- "#063D79"
      
      sig.niveau.local = ifelse(input$test.type == "Zweiseitig",
                                input$sig.niveau/2, input$sig.niveau)
      switch (input$dist,
              "Normalverteilung" = {
                x <- seq(input$axis.norm[1], input$axis.norm[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dnorm(x, mean = input$mu, sd = input$sigma), 
                                       "y2" = pnorm(x, mean = input$mu, sd = input$sigma))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Dichtefunktion der Normalverteilung") +
                  labs(y = "f(x)")
                  
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Verteilungsfunktion der Normalverteilung") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Dichtefunktion" = {
                          
                          d <- dnorm(input$dens.value, mean = input$mu, sd = input$sigma)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.norm[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                           
                        }, # END Wert der Dichtefunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          p <- pnorm(input$dist.value, mean = input$mu, sd = input$sigma)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.norm[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          q <- qnorm(input$quant.prob, mean = input$mu, sd = input$sigma)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.norm[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qnorm(sig.niveau.local, mean = input$mu, sd = input$sigma)
                  q_up <- qnorm(1 - sig.niveau.local, mean = input$mu, sd = input$sigma)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                              # shaded density
                              a <- a + 
                                geom_ribbon(data = subset(plotdata, y2 > 1 - input$sig.niveau), 
                                            aes(ymax = y1, ymin = 0), fill = uniblue)
                              
                              # shaded distribution function
                              b <- b +
                                geom_segment(aes(x = input$axis.norm[1], y = 1 - input$sig.niveau, 
                                                 xend = q_up, yend = 1 - input$sig.niveau), 
                                             linetype = "dashed", colour = uniblue) +
                                geom_segment(aes(x = q_up, y = 1 - input$sig.niveau, xend = q_up, yend = 1), 
                                             linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < input$sig.niveau), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.norm[1], y = input$sig.niveau, 
                                               xend = q_low, yend = input$sig.niveau), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = input$sig.niveau, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.norm[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.norm[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Normalverteilung
              
              "t-Verteilung" = {
                x <- seq(input$axis.t[1], input$axis.t[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dt(x, df = input$df.t), 
                                       "y2" = pt(x, df = input$df.t))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Dichtefunktion der t-Verteilung") +
                  labs(y = "f(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Verteilungsfunktion der t-Verteilung") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Dichtefunktion" = {
                          
                          d <- dt(input$dens.value, df = input$df.t)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.t[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Dichtefunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          p <- pt(input$dist.value, df = input$df.t)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.t[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          q <- qt(input$quant.prob, df = input$df.t)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.t[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qt(sig.niveau.local, df = input$df.t)
                  q_up <- qt(1 - sig.niveau.local, df = input$df.t)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - input$sig.niveau), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.t[1], y = 1 - input$sig.niveau, 
                                               xend = q_up, yend = 1 - input$sig.niveau), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - input$sig.niveau, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < input$sig.niveau), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.t[1], y = input$sig.niveau, 
                                               xend = q_low, yend = input$sig.niveau), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = input$sig.niveau, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.t[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.t[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END t-Verteilung
              
              "Chi-Quadrat-Verteilung" = {
                x <- seq(input$axis.chi[1], input$axis.chi[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dchisq(x, df = input$df.chi), 
                                       "y2" = pchisq(x, df = input$df.chi))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Dichtefunktion der Chi-Quadrat-Verteilung") +
                  labs(y = "f(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Verteilungsfunktion der Chi-Quadrat-Verteilung") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Dichtefunktion" = {
                          
                          d <- dchisq(input$dens.value, df = input$df.chi)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.chi[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Dichtefunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          p <- pchisq(input$dist.value, df = input$df.chi)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.chi[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          q <- qchisq(input$quant.prob, df = input$df.chi)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.chi[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qchisq(sig.niveau.local, df = input$df.chi)
                  q_up <- qchisq(1 - sig.niveau.local, df = input$df.chi)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.chi[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.chi[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.chi[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.chi[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Chi-Quadrat-Verteilung
              
              "F-Verteilung" = {
                x <- seq(input$axis.f[1], input$axis.f[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = df(x, df1 = input$df1, df2 = input$df2), 
                                       "y2" = pf(x, df1 = input$df1, df2 = input$df2))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Dichtefunktion der F-Verteilung") +
                  labs(y = "f(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Verteilungsfunktion der F-Verteilung") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Dichtefunktion" = {
                          
                          d <- df(input$dens.value, df1 = input$df1, df2 = input$df2)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.f[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Dichtefunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          p <- pf(input$dist.value, df1 = input$df1, df2 = input$df2)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.f[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          q <- qf(input$quant.prob, df1 = input$df1, df2 = input$df2)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.f[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qf(sig.niveau.local, df1 = input$df1, df2 = input$df2)
                  q_up <- qf(1 - sig.niveau.local, df1 = input$df1, df2 = input$df2)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.f[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.f[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.f[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.f[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END F-Verteilung
              
              "Exponentialverteilung" = {
                x <- seq(input$axis.exp[1], input$axis.exp[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dexp(x, rate = input$rate), 
                                       "y2" = pexp(x, rate = input$rate))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Dichtefunktion der Exponentialverteilung") +
                  labs(y = "f(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Verteilungsfunktion der Exponentialverteilung") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Dichtefunktion" = {
                          
                          d <- dexp(input$dens.value, rate = input$rate)
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.exp[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Dichtefunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          p <- pexp(input$dist.value, rate = input$rate)
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.exp[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          q <- qexp(input$quant.prob, rate = input$rate)
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.exp[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qexp(sig.niveau.local, rate = input$rate)
                  q_up <- qexp(1 - sig.niveau.local, rate = input$rate)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.exp[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.exp[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.exp[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.exp[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Exponentialverteilung
              
              "Stetige Gleichverteilung" = {
                x <- seq(input$axis.cu[1], input$axis.cu[2], length.out = 1000)
                plotdata <- data.frame("x" = x, 
                                       "y1" = dunif(x, min = input$axis.updown[1], max = input$axis.updown[2]), 
                                       "y2" = punif(x, min = input$axis.updown[1], max = input$axis.updown[2]))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_line() + 
                  ggtitle("Dichtefunktion der stetigen Gleichverteilung") +
                  labs(y = "f(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_line() +
                  ggtitle("Verteilungsfunktion der stetigen Gleichverteilung") +
                  labs(y = "F(x) = P(X < x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Dichtefunktion" = {
                          
                          d <- dunif(input$dens.value, min = input$axis.updown[1],
                                     max = input$axis.updown[2])
                          
                          a <- a + 
                            geom_segment(aes(x = input$axis.cu[1], y = d, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dens.value, y = 0, 
                                             xend = input$dens.value, yend = d), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Dichtefunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          p <- punif(input$dist.value, min = input$axis.updown[1], 
                                     max = input$axis.updown[2])
                          
                          a <- a +  
                            geom_ribbon(data = subset(plotdata, y2 < p), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          b <- b +
                            geom_segment(aes(x = input$axis.cu[1], y = p, 
                                             xend = input$dist.value, yend = p), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = input$dist.value, y = 0, 
                                             xend = input$dist.value, yend = 1), 
                                         linetype = "dashed", colour = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          q <- qunif(input$quant.prob, min = input$axis.updown[1], 
                                     max = input$axis.updown[2])
                          
                          a <- a +
                            geom_ribbon(data = subset(plotdata, y2 < input$quant.prob), 
                                        aes(ymax = y1, ymin = 0), fill = uniblue)
                          
                          # shaded distribution function
                          b <- b +
                            geom_segment(aes(x = input$axis.cu[1], y = input$quant.prob, 
                                             xend = q, yend = input$quant.prob), 
                                         linetype = "dashed", colour = uniblue) +
                            geom_segment(aes(x = q, y = 0, xend = q, yend = 1), 
                                         linetype = "dashed", colour = uniblue) 
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qunif(sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])
                  q_up <- qunif(1 - sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded density
                            a <- a + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.cu[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue)  
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.cu[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_ribbon(data = subset(plotdata, y2 < sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue) + 
                              geom_ribbon(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                          aes(ymax = y1, ymin = 0), fill = uniblue)
                            
                            # shaded distribution function
                            b <- b +
                              geom_segment(aes(x = input$axis.cu[1], y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1 - sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_up, y = 1 - sig.niveau.local, 
                                               xend = q_up, yend = 1), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = input$axis.cu[1], y = sig.niveau.local, 
                                               xend = q_low, yend = sig.niveau.local), 
                                           linetype = "dashed", colour = uniblue) +
                              geom_segment(aes(x = q_low, y = sig.niveau.local, 
                                               xend = q_low, yend = 1), 
                                           linetype = "dashed", colour = uniblue) 
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END stetige Gleichverteilung
              
              "Binomialverteilung" = {
                x <- input$axis.bin[1]:input$axis.bin[2]
                plotdata <- data.frame("x" = x, 
                                       "y1" = dbinom(x, size = input$size, prob = input$prob), 
                                       "y2" = pbinom(x, size = input$size, prob = input$prob))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_bar(stat = "identity") + 
                  scale_x_continuous(breaks = input$axis.bin[1]:input$axis.bin[2]) +
                  ggtitle("Wahrscheinlichkeitsfunktion der Binomialverteilung") + 
                  labs(y = "Wahrscheinlichkeit: p(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_step() +
                  scale_x_continuous(breaks = input$axis.bin[1]:input$axis.bin[2]) +
                  ggtitle("Verteilungsfunktion der Binomialverteilung") +
                  labs(y = "F(x) = P(X ≤ x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Wahrscheinlichkeitsfunktion" = {
                          
                          # d <- dbinom(input$prob.value, size = input$size, prob = input$prob)
                          
                          a <- a + 
                            geom_bar(data = subset(plotdata, x == input$prob.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Wert der Wahrscheinlichkeitsfunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          # p <- pbinom(input$dist.value, size = input$size, prob = input$prob)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, x <= input$dist.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          # q <- qbinom(input$quant.prob, size = input$size, prob = input$prob)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, y2 <= input$quant.prob), 
                                     stat="identity", fill = uniblue)
                          
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qbinom(sig.niveau.local, size = input$size, prob = input$prob)
                  q_up <- qbinom(1 - sig.niveau.local, size = input$size, prob = input$prob)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded bars 
                            a <- a + 
                              geom_bar(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                              
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local), 
                                          stat="identity", fill = uniblue)
                            
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local | y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              }, # END Binomialverteilung
              
              "Poisson-Verteilung" = {
                x <- input$axis.pois[1]:input$axis.pois[2]
                plotdata <- data.frame("x" = x, 
                                       "y1" = dpois(x, lambda = input$lambda), 
                                       "y2" = ppois(x, lambda = input$lambda))
                
                # Density
                a <- ggplot(plotdata, aes(x, y1)) +
                  geom_bar(stat = "identity") + 
                  scale_x_continuous(breaks = input$axis.pois[1]:input$axis.pois[2]) +
                  ggtitle("Wahrscheinlichkeitsfunktion der Poisson-Verteilung") + 
                  labs(y = "Wahrscheinlichkeit: p(x)")
                
                # Distribution function
                b <- ggplot(plotdata, aes(x, y2)) +
                  geom_step() +
                  scale_x_continuous(breaks = input$axis.pois[1]:input$axis.pois[2]) +
                  ggtitle("Verteilungsfunktion der Poisson-Verteilung") +
                  labs(y = "F(x) = P(X ≤ x)")
                
                switch (input$distquant,
                        "Keine" = {}, # END Keine 
                        
                        "Wert der Wahrscheinlichkeitsfunktion" = {
                          
                          # d <- dpois(input$prob.value, lambda = input$lambda)
                          
                          a <- a + 
                            geom_bar(data = subset(plotdata, x == input$prob.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Wert der Wahrscheinlichkeitsfunktion
                        
                        "Wert der Verteilungsfunktion" = {
                          
                          # p <- ppois(input$dist.value, lambda = input$lambda)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, x <= input$dist.value), 
                                     stat="identity", fill = uniblue)
                          
                        }, # END Wert der Verteilungsfunktion
                        
                        "Wert der Quantilsfunktion" = {
                          
                          # q <- qpois(input$quant.prob, lambda = input$lambda)
                          
                          a <- a +  
                            geom_bar(data = subset(plotdata, y2 <= input$quant.prob), 
                                     stat="identity", fill = uniblue)
                          
                        } # END Wert der Quantilsfunktion
                )
                
                if (input$crit.value.checkbox) {
                  
                  # Critical value
                  
                  q_low <- qpois(sig.niveau.local, lambda = input$lambda)
                  q_up <- qpois(1 - sig.niveau.local, lambda = input$lambda)
                  
                  switch (input$test.type,
                          "Rechtsseitig" = {
                            
                            # shaded bars 
                            a <- a + 
                              geom_bar(data = subset(plotdata, y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          }, # END Right-Sided
                          
                          "Linksseitig" = {
                            
                            # shaded density
                            a <- a +  
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          }, # END Left-Sided
                          
                          "Zweiseitig" = {
                            
                            # shaded density
                            a <- a +
                              geom_bar(data = subset(plotdata, y2 <= sig.niveau.local | y2 > 1 - sig.niveau.local), 
                                       stat="identity", fill = uniblue)
                            
                          } # END Two-Sided
                  ) # END switch(input$test.type)
                } # END if statement
              } # END Poisson-Verteilung
              
      ) # END switch(input$dist)
      
    } else { # makes sure that the normal distribution appears at start
             # so uses "see something" when they acess the page for the first time
      # Density function
      a <- ggplot(data.frame(x = -5:5), aes(x)) +
        stat_function(fun = dnorm) +
        ggtitle("Dichtefunktion der Normalverteilung") +
        labs(y = "f(x)")
      
      # Distribution function
      b <- ggplot(data.frame(x = -5:5), aes(x)) +
        stat_function(fun = pnorm) +
        ggtitle("Verteilungsfunktion der Normalverteilung") +
        labs(y = "F(x) = P(X < x)")
      
    } # END else statement
    
    grid.arrange(a, b) # This acutally arranges both plots for the final plot
    
  }) # END output$plot

  ### Density, Distribution, Quantile text -------------------------------------
  
  output$ddq <- renderUI({
    
    if(!input$distquant == "Keine") {
    
    seg1 <- paste0("Der ", strong(input$distquant), " der ", strong(input$dist))
    
    switch (input$dist,
            'Normalverteilung' = {
              
              param <- paste0(" mit dem Erwartungswert \\(\\mu\\) = ", code(input$mu), 
                              " und der Standardabweichung \\(\\sigma\\) = ", code(input$sigma))
              
              d <- dnorm(input$dens.value, mean = input$mu, sd = input$sigma)
              p <- pnorm(input$dist.value, mean = input$mu, sd = input$sigma)
              q <- qnorm(input$quant.prob, mean = input$mu, sd = input$sigma)
              
            }, # END Normalverteilung
            't-Verteilung' = {
              
              param <- paste0(" mit \\(k\\) = ", code(input$df.t), " Freiheitsgraden")
              
              d <- dt(input$dens.value, df = input$df.t)
              p <- pt(input$dist.value, df = input$df.t)
              q <- qt(input$quant.prob, df = input$df.t)
              
            }, # END t-Verteilung
            'Chi-Quadrat-Verteilung' = {
              
              param <- paste0(" mit \\(k\\) = ", code(input$df.chi), " Freiheitsgraden")
              
              d <- dchisq(input$dens.value, df = input$df.chi)
              p <- pchisq(input$dist.value, df = input$df.chi)
              q <- qchisq(input$quant.prob, df = input$df.chi)
            },
            'F-Verteilung' = {
              
              param <- paste0(" mit \\(k_1\\) = ", code(input$df1), " Zähler", "-", 
                              " und \\(k_2\\) = ", code(input$df2), " Nennerfreiheitsgraden")
              
              d <- df(input$dens.value, df1 = input$df1, df2 = input$df2)
              p <- pf(input$dist.value, df1 = input$df1, df2 = input$df2)
              q <- qf(input$quant.prob, df1 = input$df1, df2 = input$df2)
            },
            'Exponentialverteilung' = {
              
              param <- paste0(" mit \\(\\alpha\\) = ", code(input$rate))
              
              d <- dexp(input$dens.value, rate = input$rate)
              p <- pexp(input$dist.value, rate = input$rate)
              q <- qexp(input$quant.prob, rate = input$rate)
            },
            'Stetige Gleichverteilung' = {
              
              param <- paste0(" mit der Untergrenze \\(a\\) = ", code(input$axis.updown[1]), 
                              " und der Obergrenze \\(b\\) = ", code(input$axis.updown[2]))
              
              d <- dunif(input$dens.value, min = input$axis.updown[1], max = input$axis.updown[2])
              p <- punif(input$dist.value, min = input$axis.updown[1], max = input$axis.updown[2])
              q <- qunif(input$quant.prob, min = input$axis.updown[1], max = input$axis.updown[2])
            },
            'Binomialverteilung' = {
              
              param <- paste0(" mit \\(n\\) = ", code(input$size), " Versuchen ",
                              " und Erfolgswahrscheinlichkeit \\(p\\) = ", code(input$prob))
              
              d <- dbinom(input$prob.value, size = input$size, prob = input$prob)
              p <- pbinom(input$dist.value, size = input$size, prob = input$prob)
              q <- qbinom(input$quant.prob, size = input$size, prob = input$prob)
            },
            'Poisson-Verteilung' = {
              
              param <- paste0(" mit \\(\\lambda\\) = ", code(input$lambda))
              
              d <- dpois(input$prob.value, lambda = input$lambda)
              p <- ppois(input$dist.value, lambda = input$lambda)
              q <- qpois(input$quant.prob, lambda = input$lambda)
            }
    )
    
    switch (input$distquant,
            
            "Wert der Wahrscheinlichkeitsfunktion" = {
              
              seg2 <- ifelse(!(input$dist == "Binomialverteilung" | input$dist == "Poisson-Verteilung"),
                             paste0(" ist: ", 
                             h4(code("Stetige Verteilungen haben keine Wahrscheinlichkeitsfunktion. 
                                     Verwendet die Dichtefunktion."))),
                             paste0(" für x = ", code(input$prob.value), " ist: ", 
                                    h4(code(round(d, 4))))
              )
              
            }, # END Wert der Wahrscheinlichkeitsfunktion
            
            "Wert der Dichtefunktion" = {
              
              seg2 <- ifelse(input$dist == "Binomialverteilung" | input$dist == "Poisson-Verteilung",
                             paste0(" ist: ", 
                                    h4(code("Diskrete Verteilungen haben keine Dichtefunktion. 
                                            Verwendet die Wahrscheinlichkeitsfunktion."))),
                             paste0(" für x = ", code(input$dens.value), " ist: ", 
                                    h4(code(round(d, 4))))
                                    )
              
            }, # END Wert der Dichtefunktion
            
            "Wert der Verteilungsfunktion" = {
              
              seg2 <- paste0(" für x = ", code(input$dist.value), " ist: ", 
                             h4(code(round(p, 4))))
              
            }, # END Wert der Verteilungsfunktion
            
            "Wert der Quantilsfunktion" = {
              
              seg2 <- paste0(" für p = ", code(input$quant.prob), " ist: ", 
                             h4(code(round(q, 4))))
              
            } # END Wert der Quantilsfunktion
    )
    
    withMathJax(HTML(paste(seg1, param, seg2)))
    } # END if statement
  }) # END output$ddq
  
  ### Critical values ----------------------------------------------------------
  
  output$crit.value.text <- renderUI({

    if(input$crit.value.checkbox){

      seg1 <- paste0("Für ein einen ", strong("Signifikanzniveau"), " von:",
                     code(input$sig.niveau), ifelse(input$test.type == "Zweiseitig",
                                                        " sind die kritischen Werte der ",
                                                        " ist der kritische Werte der ")
                     , strong(input$dist))

      switch (input$dist,
              'Normalverteilung' = {

                param <- paste0(" mit dem Erwartungswert \\(\\mu\\) = ", code(input$mu),
                                " und der Standardabweichung \\(\\sigma\\) = ", code(input$sigma))

              }, # END Normalverteilung
              't-Verteilung' = {

                param <- paste0(" mit \\(k\\) = ", code(input$df.t), " Freiheitsgraden")

              }, # END t-Verteilung
              'Chi-Quadrat-Verteilung' = {

                param <- paste0(" mit \\(k\\) = ", code(input$df.chi), " Freiheitsgraden")

              },
              'F-Verteilung' = {

                param <- paste0(" mit \\(k_1\\) = ", code(input$df1), " Zähler", "-",
                                " und \\(k_2\\) = ", code(input$df2), " Nennerfreiheitsgraden")

              },
              'Exponentialverteilung' = {

                param <- paste0(" mit \\(\\alpha\\) = ", code(input$rate))

              },
              'Stetige Gleichverteilung' = {

                param <- paste0(" mit der Untergrenze \\(a\\) = ", code(input$axis.updown[1]),
                                " und der Obergrenze \\(b\\) = ", code(input$axis.updown[2]))

              },
              'Binomialverteilung' = {

                param <- paste0(" mit \\(n\\) = ", code(input$size), " Versuchen ",
                                " und Erfolgswahrscheinlichkeit \\(p\\) = ", code(input$prob))

              },
              'Poisson-Verteilung' = {

                param <- paste0(" mit \\(\\lambda\\) = ", code(input$lambda))

              }
      ) # END switch dist

      seg2 <- paste0(" bei einem ",
                     strong(ifelse(input$test.type == "Rechtsseitig", "rechtsseitigem",
                                   ifelse(input$test.type == "Linksseitig", "linksseitigem", "zweiseitigem"))),
                     " Test:")
      sig.niveau.local = ifelse(input$test.type == "Zweiseitig",
             input$sig.niveau/2, input$sig.niveau)

      switch (input$dist,
                          'Normalverteilung' = {

                            q_low <- qnorm(sig.niveau.local, mean = input$mu, sd = input$sigma)
                            q_up <- qnorm(1 - sig.niveau.local, mean = input$mu, sd = input$sigma)

                          }, # END Normalverteilung
                          't-Verteilung' = {

                            q_low <- qt(sig.niveau.local, df = input$df.t)
                            q_up <- qt(1 - sig.niveau.local, df = input$df.t)

                          }, # END t-Verteilung
                          'Chi-Quadrat-Verteilung' = {

                            q_low <- qchisq(sig.niveau.local, df = input$df.chi)
                            q_up <- qchisq(1 - sig.niveau.local, df = input$df.chi)

                          }, # END Chi-Quadrat-Verteilung
                          'F-Verteilung' = {

                            q_low <- qf(sig.niveau.local, df1 = input$df1, df2 = input$df2)
                            q_up <- qf(1 - sig.niveau.local, df1 = input$df1, df2 = input$df2)

                          },
                          'Exponentialverteilung' = {

                            q_low <- qexp(sig.niveau.local, rate = input$rate)
                            q_up <- qexp(1 - sig.niveau.local, rate = input$rate)

                          },
                          'Stetige Gleichverteilung' = {

                            q_low <- qunif(sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])
                            q_up <- qunif(1 - sig.niveau.local, min = input$axis.updown[1], max = input$axis.updown[2])

                          },
                          'Binomialverteilung' = {

                            q_low <- qbinom(sig.niveau.local, size = input$size, prob = input$prob)
                            q_up <- qbinom(1 - sig.niveau.local, size = input$size, prob = input$prob)

                          },
                          'Poisson-Verteilung' = {

                            q_low <- qpois(sig.niveau.local, lambda = input$lambda)
                            q_up <- qpois(1 - sig.niveau.local, lambda = input$lambda)

                          }
      ) # END switch dist

     crit.val <-  switch (input$test.type,
              "Rechtsseitig" = {
                h4(code(round(q_up, 4)))
              },

              "Linksseitig" = {
                h4(code(round(q_low, 4)))
              },

              "Zweiseitig" = {
                paste(h4(code(round(q_low, 4))), " und ", h4(code(round(q_up, 4))))
              }

      ) # END switch input$test.type

      withMathJax(HTML(paste(seg1, param, seg2, crit.val)))

      } # END if statement
  }) # END output$crit.value.text
  
  ### Distribution Information -------------------------------------------------
  
  output$dist.info <- renderUI({
      withMathJax(switch(input$dist,
                         'Normalverteilung' = includeMarkdown("docs/NormalDistribution.md"),
                         't-Verteilung' = includeMarkdown("docs/tDistribution.md"),
                         'Chi-Quadrat-Verteilung' = includeMarkdown("docs/ChiSquaredDistribution.md"),
                         'F-Verteilung' = includeMarkdown("docs/FDistribution.md"),
                         'Exponentialverteilung' = includeMarkdown("docs/ExponentialDistribution.md"),
                         'Stetige Gleichverteilung' = includeMarkdown("docs/UniformDistribution.md"),
                         'Binomialverteilung' = includeMarkdown("docs/BinomialDistribution.md"),
                         'Poisson-Verteilung' = includeMarkdown("docs/PoissonDistribution.md")
      )) # END switch
    }) # END output$dist.info
}) # END shinyServer